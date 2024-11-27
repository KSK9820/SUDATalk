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
    private let repositiory = ChannelChatRepository()
    private let socketManager: SocketIOManager
    private var ongoingRequests: Set<String> = []
    
    @Published var channel: ChannelListPresentationModel?
    @Published var workspaceID: String = ""
    @Published var messageText: String = ""
    @Published var selectedImages: [UIImage] = []
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
        if let chatDatafromDB = repositiory?.fetchChatting(channelID) {
            chatting = chatDatafromDB
            
            if let lastChatDate = chatDatafromDB.last?.createdAt {
                fetchChatFromNetwork(workspaceID, channelID: channelID, date: lastChatDate.toString(style: .iso))
            } else {
                fetchChatFromNetwork(workspaceID, channelID: channelID, date: Date().toString(style: .iso))
            }
        }
    }
    // MARK: - troubleShooting
    private func fetchChatFromNetwork(_ workspaceID: String, channelID: String, date: String?) {
        do {
            guard let date else { return }
            let requestChannel = try ChannelRouter.fetchChat(workspaceID: workspaceID, channelID: channelID, date: date).makeRequest()
            print("********")
            print(requestChannel.url)
            print(requestChannel.httpMethod)
            print(requestChannel.allHTTPHeaderFields)
            print(workspaceID, channelID, date)
            
            networkManager.getDecodedDataTaskPublisher(requestChannel, model: [SendChatResponse].self)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    print("빈배열이 나와야함", value)
                    value.forEach { item in
                        DispatchQueue.main.async {
                            let chat = item.convertToModel()

                            self.chatting.append(chat)
                            self.repositiory?.addChannelChat(chat)
                            self.connectSocket()
                        }
                    }
                })
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    
    func sendMessage(workspaceID: String, channelID: String, content: String, images: [UIImage]) {
        let imageData = ImageConverter.shared.convertToData(images: images)
        let query = ChatQuery(content: content, files: imageData)
        let requestKey = generateRequestKey(for: query)
        
        do {
            guard !ongoingRequests.contains(requestKey) else { return }
            ongoingRequests.insert(requestKey)
            
            let requestChannel = try ChannelRouter.sendChat(workspaceID: workspaceID, channelID: channelID, query: query).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(requestChannel, model: SendChatResponse.self)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                    
                    self?.ongoingRequests.remove(requestKey)
                }, receiveValue: { [weak self] value in
                    if !value.files.isEmpty {
                        value.files.enumerated().forEach { (index, url) in
                            ImageFileManager.shared.saveImageToDocument(image: images[index], fileUrl: url)
                        }
                    }
                    
                    self?.repositiory?.addChannelChat(value.convertToModel())
                    self?.chatting.append(value.convertToModel())
                    self?.messageText = ""
                    self?.selectedImages = []
                })
                .store(in: &cancellables)
        } catch {
            print(error)
            ongoingRequests.remove(requestKey)
        }
    }
    
    private func generateRequestKey(for query: ChatQuery) -> String {
            let content = query.content
            let files = query.files.map { $0.base64EncodedString() }.joined(separator: ",")
            return "\(content)-\(files)"
        }

    func fetchImages(_ urls: [String], index: Int) async {
        var chatImages: [Data?] = Array(repeating: nil, count: urls.count)

        for (index, url) in urls.enumerated() {
            if let cachedImage = CacheManager.shared.loadFromCache(forKey: url) {
                chatImages[index] = cachedImage
                continue
            }
            
            if let fileManagerImage = ImageFileManager.shared.loadFile(fileUrl: url) {
                chatImages[index] = fileManagerImage
                CacheManager.shared.saveToCache(data: fileManagerImage, forKey: url)
                continue
            }
            
            do {
                let value = try await fetchImageFromNetwork(url: url)
                CacheManager.shared.saveToCache(data: value, forKey: url)
                chatImages[index] = value

                if let image = UIImage(data: value) {
                    ImageFileManager.shared.saveImageToDocument(image: image, fileUrl: url)
                }
            } catch {
                print("Error fetching image from network: \(error)")
                chatImages[index] = nil
                continue
            }
        }

        self.chatting[index].images = chatImages
    }

    private func fetchImageFromNetwork(url: String) async throws -> Data {
        let requestChannel = try ChannelRouter.fetchImage(url: url).makeRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            networkManager.getDataTaskPublisher(requestChannel)
                .sink { completion in
                    if case .failure(let failure) = completion {
                        continuation.resume(throwing: failure)
                    }
                } receiveValue: { value in
                    continuation.resume(returning: value)
                }
                .store(in: &cancellables)
        }
    }
    
    func fetchProfileImages(_ url: String, index: Int) async {
        if let cachedImage = CacheManager.shared.loadFromCache(forKey: url) {
            chatting[index].user.profileImageData = cachedImage
            return
        }

        do {
            let value = try await fetchImageFromNetwork(url: url)
            CacheManager.shared.saveToCache(data: value, forKey: url)
            chatting[index].user.profileImageData = value

        } catch {
            print("Error fetching image from network: \(error)")
        }
    }
    
//    func fetchProfileImages(_ url: String) async -> Data? {
//        if let cachedImage = CacheManager.shared.loadFromCache(forKey: url) {
//            return cachedImage
//        }
//
//        do {
//            let value = try await fetchImageFromNetwork(url: url)
//            CacheManager.shared.saveToCache(data: value, forKey: url)
//            
//            return value
//        } catch {
//            print("Error fetching image from network: \(error)")
//            return nil
//        }
//    }
    
    func connectSocket() {
        socketManager.connect()
        getRealtimeMessage()
    }
    
    private func getRealtimeMessage() {
        socketManager.publisher
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                
                if let decodedData = data as? SendChatResponse {
                    guard let userID = self.userID, userID != decodedData.user.userID else { return }
                    self.chatting.append(decodedData.convertToModel())
                    self.repositiory?.addChannelChat(decodedData.convertToModel())
                }
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
