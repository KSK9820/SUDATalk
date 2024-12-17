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
    
    @Published var input = ChannelChatInputModel(content: "", images: [])
    @Published var channel: ChannelListPresentationModel?
    @Published var workspaceID: String = ""
    @Published var chatting: [ChattingPresentationModel] = []
    let myProfile = UserDefaultsManager.shared.userProfile
    var myProfileImage: Image {
        if let data = UserDefaultsManager.shared.userProfile.profileImageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Images.userDefaultImage
        }
    }
    
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
                fetchChatFromNetwork(workspaceID, channelID: channelID, date: lastChatDate.toiso8601String())
            } else {
                fetchChatFromNetwork(workspaceID, channelID: channelID, date: "")
            }
        }
    }
    
    private func fetchChatFromNetwork(_ workspaceID: String, channelID: String, date: String?) {
        do {
            guard let date else { return }
            let requestChannel = try ChannelRouter.fetchChat(workspaceID: workspaceID, channelID: channelID, date: date).makeRequest()

            networkManager.getDecodedDataTaskPublisher(requestChannel, model: [SendChatResponse].self)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] value in
                    guard let self = self else { return }

                    value.forEach { item in
                        DispatchQueue.main.async {
                            let chat = item.convertToModel()

                            self.chatting.append(chat)
                            self.repositiory?.addChannelChat(chat)
                        }
                    }
                    
                    self.connectSocket()
                })
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func sendMessage(workspaceID: String, channelID: String, input: ChannelChatInputModel) {
        let imageData = ImageConverter.shared.convertToData(images: input.images)
        let query = ChatQuery(content: input.content, files: imageData)
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
                    self?.input.content = ""
                    self?.input.images = []
                    self?.repositiory?.addChannelChat(value.convertToModel())
                    self?.chatting.append(value.convertToModel())
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
        var chatImages: [Image?] 
        
        if chatting[index].images.count == 0 {
            chatImages = Array(repeating: nil, count: urls.count)
        } else {
            chatImages = chatting[index].images
        }
        
        await withTaskGroup(of: (Int, Data?).self) { group in
            for (idx, url) in urls.enumerated() {
                if chatting[index].checkImages.contains(url) {
                    continue
                } else {
                    chatting[index].checkImages.insert(url)
                    
                    group.addTask { [weak self] in
                        guard let self else {
                            return (idx, nil)
                        }
                        
                        do {
                            let imageData = try await self.fetchImageFromNetwork(url: url)
                            
                            return (idx, imageData)
                        } catch {
                            print("Error: \(error)")
                            return (idx, nil)
                        }
                    }
                }
            }
            
            for await (idx, data) in group {
                guard let data, let uiImage = UIImage(data: data) else { return }
                chatImages[idx] = Image(uiImage: uiImage)
            }
        }

        self.chatting[index].images = chatImages
    }
    
    private func fetchImageFromNetwork(url: String) async throws -> Data {
        let request = try ChannelRouter.fetchImage(url: url).makeRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            _ = networkManager.getCachingImageDataTaskPublisher(request: request, key: url)
                .sink { completion in
                    if case .failure(let error) = completion {
                        continuation.resume(throwing: error)
                    }
                } receiveValue: { value in
                    continuation.resume(returning: value)
                }
        }
    }
    
    func fetchProfileImages(_ url: String, index: Int) async {
        if let cachedImage = CacheManager.shared.loadFromCache(forKey: url) {
            guard let uiImage = UIImage(data: cachedImage) else { return }
            chatting[index].user.profileImage = Image(uiImage: uiImage)
            
            return
        }

        do {
            let value = try await fetchImageFromNetwork(url: url)
            CacheManager.shared.saveToCache(data: value, forKey: url)
            guard let uiImage = UIImage(data: value) else { return }
            
            chatting[index].user.profileImage = Image(uiImage: uiImage)

        } catch {
            print("Error fetching image from network: \(error)")
        }
    }
    
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
                    guard self.myProfile.userID != decodedData.user.userID else { return }
                    self.chatting.append(decodedData.convertToModel())
                    self.repositiory?.addChannelChat(decodedData.convertToModel())
                }
            }
            .store(in: &cancellables)
    }
    
    func profileImage(userID: String, url: String, index: Int) async {
        if userID == myProfile.userID {
            guard let data = myProfile.profileImageData, let uiImage = UIImage(data: data) else { return }
            self.chatting[index].user.profileImage = Image(uiImage: uiImage)
        } else {
            await fetchProfileImages(url, index: index)
        }
    }
    
    func disconnectSocket() {
        socketManager.connect()
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
