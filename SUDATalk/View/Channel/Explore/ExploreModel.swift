//
//  ExploreModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Combine
import Foundation

final class ExploreModel: ObservableObject, ExploreModelStateProtocol {
    private var cancellables: Set<AnyCancellable> = []
    private let networkManager = NetworkManager()
    private let repository = ChannelChatRepository()
    
    @Published var workspaceID: String = SampleTest.workspaceID
    @Published var channelList: [ChannelListPresentationModel] = []
    @Published var showAlert: Bool = false
}

extension ExploreModel: ExploreActionsProtocol {
    func fetchChennelList(_ workspaceID: String) {
        do {
            let requestChannel = try ChannelRouter.channelList(param: workspaceID).makeRequest()
            let requestMyChannel = try ChannelRouter.myChannelList(param: workspaceID).makeRequest()
            
            let requestChannelPublisher = networkManager.getDecodedDataTaskPublisher(requestChannel, model: [ExploreResponse].self)
            let requestMyChannelPublisher = networkManager.getDecodedDataTaskPublisher(requestMyChannel, model: [ExploreResponse].self)
            
            requestChannelPublisher
                .zip(requestMyChannelPublisher)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] returnedChannelItems, returnedMyChannelItems in
                    self?.channelList = returnedChannelItems.map { item in
                        DispatchQueue.main.async {
                            self?.repository?.createChannel(item.convertToModel())
                        }
                         var newItem = item.convertToModel()
                         if returnedMyChannelItems.contains(where: { $0.channelID == item.channelID }) {
                             newItem.isMyChannel = true
                         }
                         return newItem
                     }
                })
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func toggleAlert() {
        self.showAlert.toggle()
    }
}
