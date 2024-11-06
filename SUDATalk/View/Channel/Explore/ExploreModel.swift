//
//  ExploreModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Combine
import Foundation

final class ExploreModel: ObservableObject, ExploreModelStateProtocol {
    var cancellables: Set<AnyCancellable> = []
    let networkManager = NetworkManager(dataTaskServices: DataTaskServices(), decodedServices: DecodedServices())
    
    @Published var workspaceID: String = SampleTest.workspaceID
    @Published var channelList: [ChannelListPresentationModel] = []
    @Published var showAlert: Bool = false
}

extension ExploreModel: ExploreActionsProtocol {
    func fetchChennelList(_ workspaceID: String) {
        do {
            let requestChannel = try ChannelRouter.channel(param: workspaceID).makeRequest()
            let requestMyChannel = try ChannelRouter.myChannel(param: workspaceID).makeRequest()
            
            let requestChannelPublisher = networkManager.fetchDecodedData(requestChannel, model: [ExploreResponse].self)
            let requestMyChannelPublisher = networkManager.fetchDecodedData(requestMyChannel, model: [ExploreResponse].self)
            
            requestChannelPublisher
                .zip(requestMyChannelPublisher)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] returnedChannelItems, returnedMyChannelItems in
                    returnedChannelItems.forEach { item in
                        var newItem = item.convertToModel()
                        if returnedMyChannelItems.contains(where: { $0.channelID == item.channelID }) {
                            newItem.isMyChannel = true
                        }
                        self?.channelList.append(newItem)
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
