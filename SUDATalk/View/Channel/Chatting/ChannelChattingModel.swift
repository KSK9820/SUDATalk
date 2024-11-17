//
//  ChannelChattingModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import Combine
import SwiftUI

final class ChannelChattingModel: ObservableObject, ChannelChattingModelStateProtocol {  
    private var cancellables: Set<AnyCancellable> = []
    private let networkManager = NetworkManager()
    private let repositiory = ChattingRepository()
    private let socketManager:SocketIOManager
    
    @Published var channel: ChannelListPresentationModel?
    @Published var workspaceID: String = ""
    @Published var messageText: String = ""
    @Published var selectedImages: [UIImage] = []
    @Published var uploadStatus: Bool = false
    @Published var chatting: [ChattingPresentationModel] = []
    @AppStorage("userID") var userID: String?
    
    init(socketManager: SocketIOManager) {
        self.socketManager = socketManager
    }
    
    deinit {
        socketManager.disconnect()
    }
}

extension ChannelChattingModel: ChannelChattingActionsProtocol {
    func setChattingData(workspaceID: String, channelID: String) {
        guard let chatDatafromDB = repositiory?.fetchChatting(channelID) else { return }
        chatting = chatDatafromDB
        
        guard let lastChatDate = chatDatafromDB.last?.createdAt else { return }

          do {
            let requestChannel = try ChannelRouter.fetchChat(workspaceID: workspaceID, channelID: channelID, date: lastChatDate).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(requestChannel, model: [SendChatResponse].self)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] value in
                    value.forEach { item in
                        DispatchQueue.main.async {
                            self?.chatting.append(item.convertToModel())
                            self?.repositiory?.addChatting(item)
                        }
                    }
                })
                .store(in: &cancellables)
        } catch {
            print(error)
        }
        
        connectSocket()
    }
    
    func sendMessage(workspaceID: String, channelID: String, content: String, images: [UIImage]) {
        do {
            let imageData = ImageConverter.shared.convertToData(images: images)
            let query = ChatQuery(content: content, files: imageData)
            let requestChannel = try ChannelRouter.sendChat(workspaceID: workspaceID, channelID: channelID, query: query).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(requestChannel, model: SendChatResponse.self)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] value in
                    print(value)
                    if !value.files.isEmpty {
                        value.files.enumerated().forEach { (index, url) in
                            ImageFileManager.shared.saveImageToDocument(image: images[index], fileUrl: url)
                        }
                    }
                    
                    self?.repositiory?.addChatting(value)
                    self?.chatting.append(value.convertToModel())
                    self?.uploadStatus = true
                })
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func fetchImages(_ urls: [String], index: Int) {
        let dispatchGroup = DispatchGroup()
        var chatImages: [Data] = []

        urls.forEach { url in
            if let cachedImage = ImageCacheManager.shared.loadImageFromCache(forKey: url) {
                chatImages.append(cachedImage)
                return
            }
            
            if let fileManagerImage = ImageFileManager.shared.loadFile(fileUrl: url) {
                chatImages.append(fileManagerImage)
                ImageCacheManager.shared.saveImageToCache(imageData: fileManagerImage, forKey: url)
                return
            }
            
            dispatchGroup.enter()
            
            do {
                let requestChannel = try ChannelRouter.fetchImage(url: url).makeRequest()

                networkManager.getDataTaskPublisher(requestChannel)
                    .sink { completion in
                        if case .failure(let failure) = completion {
                            print(failure)
                            dispatchGroup.leave()
                        }
                    } receiveValue: { value in
                        ImageCacheManager.shared.saveImageToCache(imageData: value, forKey: url)
                        chatImages.append(value)
                        if let image = UIImage(data: value) {
                            ImageFileManager.shared.saveImageToDocument(image: image, fileUrl: url)
                        }
                        dispatchGroup.leave()
                    }
                    .store(in: &cancellables)
            } catch {
                print("Error: \(error)")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.chatting[index].images = chatImages
        }
    }
    
    func fetchProfileImages(_ url: String, index: Int) {
        if let cachedImage = ImageCacheManager.shared.loadImageFromCache(forKey: url) {
            chatting[index].user.profileImageData = cachedImage
            return
        }
        
        do {
            let requestChannel = try ChannelRouter.fetchImage(url: url).makeRequest()
            
            networkManager.getDataTaskPublisher(requestChannel)
                .sink { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                } receiveValue: { [weak self] value in
                    ImageCacheManager.shared.saveImageToCache(imageData: value, forKey: url)
                    self?.chatting[index].user.profileImageData = value
                }
                .store(in: &cancellables)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func connectSocket() {
        socketManager.connect()

        socketManager.getChatSubject()
            .sink {  completion in
                if case .failure(let failure) = completion {
                    print(failure)
                }
            } receiveValue: { [weak self] value in
                guard let userID = self?.userID, userID != value.user.userID else { return }
                self?.chatting.append(value.convertToModel())
                self?.repositiory?.addChatting(value)
            }
            .store(in: &cancellables)
    }
    
    func disconnectSocket() {
        socketManager.connect()
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
