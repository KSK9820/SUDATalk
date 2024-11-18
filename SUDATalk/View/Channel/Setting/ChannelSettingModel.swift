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
    private let repositiory = ChattingRepository()
    
    @Published var channelID: String = ""
    @Published var workspaceID: String = ""
    @Published var channel = ChannelPresentationModel()
    @Published var goToList = false
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
        if let cachedImage = ImageCacheManager.shared.loadImageFromCache(forKey: url) {
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
                    ImageCacheManager.shared.saveImageToCache(imageData: value, forKey: url)
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
                }, receiveValue: { [weak self] value in
                    print(value)
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
        print("editChannel")
    }
    
    func changeAdmin() {
        print("changeAdmin")
    }
    
    func deleteChannel() {
        print("deleteChannel")
    }
}
