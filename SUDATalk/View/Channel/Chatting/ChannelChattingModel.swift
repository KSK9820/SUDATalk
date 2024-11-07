//
//  ChannelChattingModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import Combine
import SwiftUI

final class ChannelChattingModel: ObservableObject, ChannelChattingModelStateProtocol {  
    var cancellables: Set<AnyCancellable> = []
    private let networkManager = NetworkManager(dataTaskServices: DataTaskServices(), decodedServices: DecodedServices())
    
    @Published var channel: ChannelListPresentationModel?
    @Published var workspaceID: String = ""
    @Published var messageText: String = ""
    @Published var selectedImages: [UIImage] = []
    @Published var uploadStatus: Bool = false
    @Published var chatting: [ChattingPresentationModel] = []
}

extension ChannelChattingModel: ChannelChattingActionsProtocol {
    func viewOnAppear(workspaceID: String, channelID: String, date: String) {
        do {
            let requestChannel = try ChannelRouter.fetchChat(workspaceID: workspaceID, channelID: channelID, date: date).makeRequest()

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
    
    func sendMessage(workspaceID: String, channelID: String, query: ChatQuery) {
        do {
            let requestChannel = try ChannelRouter.sendChat(workspaceID: workspaceID, channelID: channelID, query: query).makeRequest()

            networkManager.fetchDecodedData(requestChannel, model: SendChatResponse.self)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print("dd", failure)
                    }
                }, receiveValue: { [weak self] value in
                    print(value)
                    self?.repositiory?.addChatting(value)
                    self?.uploadStatus = true
                })
                .store(in: &cancellables)
        } catch {
            print("ee", error)
        }
    }
    
    func fetchImages(_ urls: [String], index: Int) {
        let dispatchGroup = DispatchGroup()
        var chatImages: [Data] = []

        urls.forEach { url in
            do {
                let requestChannel = try ChannelRouter.fetchImage(url: url).makeRequest()
                
                dispatchGroup.enter()
                
                networkManager.fetchData(requestChannel)
                    .sink { completion in
                        if case .failure(let failure) = completion {
                            print(failure)
                            dispatchGroup.leave()
                        }
                    } receiveValue: { value in
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
            self?.chatting[index].images.append(contentsOf: chatImages)
        }
    }
}
