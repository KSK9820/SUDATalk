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
    private let networkManager = NetworkManager(dataTaskServices: DataTaskServices(), decodedServices: DecodedServices())
    private let repositiory = ChattingRepository()
    
    @Published var channel: ChannelListPresentationModel?
    @Published var workspaceID: String = ""
    @Published var messageText: String = ""
    @Published var selectedImages: [UIImage] = []
    @Published var uploadStatus: Bool = false
    @Published var chatting: [ChattingPresentationModel] = []
}

extension ChannelChattingModel: ChannelChattingActionsProtocol {
    func viewOnAppear(workspaceID: String, channelID: String) {
        guard let chatDatafromDB = repositiory?.fetchChatting(channelID) else { return }
        chatting.append(contentsOf: chatDatafromDB)
        
        guard let lastChatDate = chatDatafromDB.last?.createdAt else { return }

          do {
            let requestChannel = try ChannelRouter.fetchChat(workspaceID: workspaceID, channelID: channelID, date: lastChatDate).makeRequest()
            
            networkManager.fetchDecodedData(requestChannel, model: [SendChatResponse].self)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] value in
                    value.forEach { item in
                        self?.chatting.append(item.convertToModel())
                    }
                })
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func sendMessage(workspaceID: String, channelID: String, content: String, images: [UIImage]) {
        do {
            let imageData = ImageConverter.shared.convertToData(images: images)
            let query = ChatQuery(content: content, files: imageData)
            let requestChannel = try ChannelRouter.sendChat(workspaceID: workspaceID, channelID: channelID, query: query).makeRequest()
            
            networkManager.fetchDecodedData(requestChannel, model: SendChatResponse.self)
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
            if let cachedImage = ImageCacheManager.shard.loadImageFromCache(forKey: url) {
                chatImages.append(cachedImage)
                return
            }
            
            if let fileManagerImage = ImageFileManager.shared.loadFile(fileUrl: url) {
                chatImages.append(fileManagerImage)
                ImageCacheManager.shard.saveImageToCache(imageData: fileManagerImage, forKey: url)
                return
            }
            
            dispatchGroup.enter()
            
            do {
                let requestChannel = try ChannelRouter.fetchImage(url: url).makeRequest()

                networkManager.fetchData(requestChannel)
                    .sink { completion in
                        if case .failure(let failure) = completion {
                            print(failure)
                            dispatchGroup.leave()
                        }
                    } receiveValue: { value in
                        ImageCacheManager.shard.saveImageToCache(imageData: value, forKey: url)
                        chatImages.append(value)
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
}
