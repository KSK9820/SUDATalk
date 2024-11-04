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
    let networkManager = NetworkManager(dataTaskServices: DataTaskServices(), decodedServices: DecodedServices())
    
    @Published var channel: ChannelList?
    @Published var workspaceID: String = ""
    @Published var messageText: String = ""
    @Published var selectedImages: [UIImage] = []
}

extension ChannelChattingModel: ChannelChattingActionsProtocol {
    
    func sendMessage(workspaceID: String, channelID: String, query: ChatQuery) {
        do {
            let requestChannel = try ChannelRouter.chat(workspaceId: workspaceID, channelID: channelID, query: query).makeRequest()

            networkManager.fetchDecodedData(requestChannel, model: SendChatResponse.self)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { value in
                    print(value)
                })
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
}
