//
//  DMChatModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Combine
import SwiftUI
import UIKit

final class DMChatModel: ObservableObject, DMModelStateProtocol {
    private let networkManager = NetworkManager()
    private let socketManager = SocketIOManager(event: DMSocketEvent(roomID: SampleTest.roomID))
    private let repository = DMChatRepository()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var dmInput: DMChatSendPresentationModel = DMChatSendPresentationModel()
    @Published var realtimeMessage = DMChatPresentationModel()
    @Published var chatting: [DMChatPresentationModel] = []
    
    var dmRoomInfo: DMRoomInfoPresentationModel
    var opponentProfileImage: Image {
        if let profileImageData = dmRoomInfo.user.profileImageData {
            Image(uiImage: profileImageData)
        } else {
            Images.userDefaultImage
        }
    }
    
    init(_ dmRoomInfo: DMRoomInfoPresentationModel) {
        self.dmRoomInfo = dmRoomInfo
    }
}

extension DMChatModel: DMModelActionProtocol {
    func setDMChatView() {
        readSavedMessage()
    }
    
    func fetchImages(urls: [String], index: Int) {
        let dispatchGroup = DispatchGroup()
        var chatImages: [Data?] = Array(repeating: nil, count: urls.count)
        
        urls.enumerated().forEach { (index, url) in
            if let cachedImage = ImageCacheManager.shared.loadImageFromCache(forKey: url) {
                chatImages[index] = cachedImage
                return
            }
            
            if let fileManagerImage = ImageFileManager.shared.loadFile(fileUrl: url) {
                chatImages[index] = fileManagerImage
                ImageCacheManager.shared.saveImageToCache(imageData: fileManagerImage, forKey: url)
                return
            }
            
            dispatchGroup.enter()
            
            do {
                let request = try DMRouter.fetchImage(url: url).makeRequest()
                
                networkManager.getDataTaskPublisher(request)
                    .sink { completion in
                        if case .failure(let failure) = completion {
                            print(failure)
                            dispatchGroup.leave()
                        }
                    } receiveValue: { value in
                        ImageCacheManager.shared.saveImageToCache(imageData: value, forKey: url)
                        
                        if let image = UIImage(data: value) {
                            ImageFileManager.shared.saveImageToDocument(image: image, fileUrl: url)
                        }
                        
                        chatImages[index] = value
                        dispatchGroup.leave()
                    }
                    .store(in: &cancellables)
            } catch {
                print("Error: \(error)")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.chatting[index].dataFiles = chatImages
        }
    }
    
    func sendMessage(query: DMChatSendPresentationModel) {
        do {
            let DMQuery = query.toDTOModel()
            let request = try DMRouter.chats(workspaceID: SampleTest.workspaceID, roomID: dmRoomInfo.roomID, body: DMQuery).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: DMChatResponse.self)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                } receiveValue: { [weak self] _ in
                    guard let self else { return }
                    
                    dmInput.content = ""
                    dmInput.files = []
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func disconnectSocket() {
        socketManager.disconnect()
    }
    
    private func connectSocket() {
        socketManager.connect()
        getRealtimeMessage()
    }
    
    private func readSavedMessage() {
        if let savedMessage = repository?.readDMChat(dmRoomInfo.roomID) {
            chatting = savedMessage
            if let lastMessageDate = savedMessage.last?.createdAt {
                readUnreadMessage(lastMessageDate)
            } else {
                readUnreadMessage()
            }
        }
        
        connectSocket()
    }
    
    private func readUnreadMessage(_ date: Date? = nil) {
        do {
            let request: URLRequest
            
            if let date {
                request = try DMRouter.unreadChats(workSpaceID: SampleTest.workspaceID, roomID: dmRoomInfo.roomID, cursorDate: date).makeRequest()
            } else {
                request = try DMRouter.unreadChats(workSpaceID: SampleTest.workspaceID, roomID: dmRoomInfo.roomID).makeRequest()
            }
            
            networkManager.getDecodedDataTaskPublisher(request, model: [DMChatResponse].self)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                } receiveValue: { [weak self] value in
                    guard let self else { return }
                    
                    let chatData = value.map { $0.toModel() }
                    
                    repository?.addDMChat(DMChatRoomPresentationModel(roomID: realtimeMessage.roomID, chat: chatData))
                    self.chatting.append(contentsOf: chatData)
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    private func getRealtimeMessage() {
        socketManager.publisher
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                
                if let decodedData = data as? DMChatResponse {
                    let chatData = decodedData.toModel()
                    
                    if chatData.user.userID == dmRoomInfo.user.userID {
                        fetchProfileImage(chatData.user.profileImage)
                    }
                    realtimeMessage = chatData
                    repository?.addDMChat(DMChatRoomPresentationModel(roomID: realtimeMessage.roomID, chat: [realtimeMessage]))
                    chatting.append(chatData)
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchProfileImage(_ url: String?) {
        if url == dmRoomInfo.user.profileImage { return }
        if let url = url {
            do {
                let request = try DMRouter.fetchImage(url: url).makeRequest()
                
                networkManager.getDataTaskPublisher(request)
                    .sink { completion in
                        if case .failure(let failure) = completion {
                            print(failure)
                            
                        }
                    } receiveValue: { [weak self] value in
                        guard let self else { return }
                        
                        if let outdatedProfileImage = dmRoomInfo.user.profileImage {
                            ImageCacheManager.shared.removeImageFromCache(forKey: outdatedProfileImage)
                        }
                        
                        ImageCacheManager.shared.saveImageToCache(imageData: value, forKey: url)
                        dmRoomInfo.user.profileImage = url
                        dmRoomInfo.user.profileImageData = UIImage(data: value)
                    }
                    .store(in: &cancellables)
            } catch {
                print("Error: \(error)")
            }
        } else {
            dmRoomInfo.user.profileImage = nil
            dmRoomInfo.user.profileImageData = UIImage.userDefault
        }
    }
}
