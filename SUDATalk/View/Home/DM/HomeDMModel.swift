//
//  HomeDMModel.swift
//  SUDATalk
//
//  Created by 김수경 on 12/6/24.
//

import Combine
import UIKit
import SwiftUI

final class HomeDMModel: ObservableObject, HomeDMModelStateProtocol {
    private let networkManager = NetworkManager()
    private let repository = DMChatRepository()
    private var cancellables = Set<AnyCancellable>()
    
    var workspace: String
    
    init(workspace: String) {
        self.workspace = workspace
    }
    
    @Published var dmlist: [DMRoomInfoPresentationModel] = []
}

extension HomeDMModel: HomeDMActionProtocol {
    func getDMList() {
        do {
            let request = try DMRouter.dmlist(workspaceID: workspace).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: [DMRoomInfoResponse].self)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self]  value in
                    guard let self else { return }
                    
                    dmlist = value.map { $0.convertToModel() }.sorted { $0.createdAt < $1.createdAt }
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func fetchThumbnail(_ url: String, idx: Int) {
        do {
            let request = try DMRouter.fetchImage(url: url).makeRequest()
            
            networkManager.getCachingImageDataTaskPublisher(request: request, key: url)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    guard let self else { return }
                    
                    self.dmlist[idx].user.profileImageData = value
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func getUnreadChatCount(idx: Int, roomID: String) {
        do {
            let request: URLRequest
            
            if let date = repository?.readDMChat(roomID).last?.createdAt {
                request = try DMRouter.unreadChats(workSpaceID: workspace, roomID: roomID, cursorDate: date).makeRequest()
            } else {
                request = try DMRouter.unreadChats(workSpaceID: workspace, roomID: roomID).makeRequest()
            }
            
            networkManager.getDecodedDataTaskPublisher(request, model: [DMChatResponse].self)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    guard let self else { return }
                    
                    if value.count > 0 {
                        dmlist[idx].unreadChat = value.map { $0.convertToModel() }
                    } else {
                        if let lastChat = repository?.readDMChat(roomID).last {
                            dmlist[idx].lastChat = lastChat
                        }
                    }
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
}
