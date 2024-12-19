//
//  ExploreModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Combine
import SwiftUI

final class ExploreModel: ObservableObject, ExploreModelStateProtocol {
    private var cancellables: Set<AnyCancellable> = []
    private let networkManager = NetworkManager()
    private let repository = ChannelChatRepository()
    
    var workspaceID: String
    
    @Published var channelList: [ChannelListPresentationModel] = []
    @Published var showAlert: Bool = false
    
    init(workspaceID: String) {
        self.workspaceID = workspaceID
    }
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
                    self?.channelList = returnedChannelItems.enumerated().map { (index, item) in
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
    
    func getUnreadChatCount(idx: Int, channelID: String) {
        do {
            guard let chatDatafromDB = repository?.fetchChatting(channelID).last?.createdAt else { return }
            let request = try ChannelRouter.unreads(workspaceID: workspaceID, channelID: channelID, date: chatDatafromDB.toiso8601String()).makeRequest()

            networkManager.getDecodedDataTaskPublisher(request, model: UnreadChatResponse.self)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    guard let self else { return }

                    if value.count > 0 {
                        channelList[idx].unreadsCount = value.count
                    }
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func toggleAlert() {
        self.showAlert.toggle()
    }
    
    func resetUnreadChatCount(idx: Int) {
        channelList[idx].unreadsCount = 0
    }
    
    func fetchThumbnail(_ url: String, idx: Int) {
        do {
            let request = try ChannelRouter.fetchImage(url: url).makeRequest()
            
            networkManager.getCachingImageDataTaskPublisher(request: request, key: url)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    guard let self else { return }
                    
                    if let uiImage = UIImage(data: value) {
                        self.channelList[idx].coverImage = Image(uiImage: uiImage)
                    }
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
}
