//
//  ChannelSettingModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import Combine
import Foundation

final class ChannelSettingModel: ObservableObject, ChannelSettingModelStateProtocol {
    private var cancellables: Set<AnyCancellable> = []
    private var networkManager = NetworkManager()
    private let repositiory = ChannelChatRepository()
    
    @Published var channelID: String = ""
    @Published var workspaceID: String = ""
    @Published var channel = ChannelPresentationModel()
    @Published var goToList = false
    @Published var selectedSheet: ChannelEditAction?
}

extension ChannelSettingModel: ChannelSettingActionProtocol {
    func getChannelInfo() {
        do {
            let request = try ChannelRouter.channel(workspaceID: workspaceID, channelID: channelID).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: ChannelResponse.self)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] value in
                    self?.channel = value.convertToModel()
                })
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func fetchProfileImages(_ url: String, index: Int) {
        if let cachedImage = CacheManager.shared.loadFromCache(forKey: url) {
            channel.channelMembers[index].profileImageData = cachedImage
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
                    CacheManager.shared.saveToCache(data: value, forKey: url)
                    self?.channel.channelMembers[index].profileImageData = value
                }
                .store(in: &cancellables)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func exitChannel() {
        do {
            let request = try ChannelRouter.exitChannel(workspaceID: workspaceID, channelID: channelID).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: [ChannelListResponse].self)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.repositiory?.deleteChatting(self?.channelID ?? "")
                        self?.goToList = true
                    }
                })
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func editChannel() {
        selectedSheet = .editChannel
    }
    
    func changeAdmin() {
        selectedSheet = .changeAdmin
    }
    
    func deleteChannel() {
        do {
            let request = try ChannelRouter.deleteChannel(workspaceID: workspaceID, channelID: channelID).makeRequest()
            
            networkManager.getDataTaskPublisher(request)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.repositiory?.deleteChatting(self?.channelID ?? "")
                        self?.goToList = true
                    }
                })
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func updateChannel(_ newChannel: ChannelListPresentationModel) {
        channel.name = newChannel.name
        channel.description = newChannel.description
    }
}
