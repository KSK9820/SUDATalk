//
//  DMListModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import Combine
import SwiftUI

final class DMListModel: ObservableObject, DMListModelStateProtocol {
    private let networkManager = NetworkManager()
    private let repository = DMChatRepository()
    private var cancellables = Set<AnyCancellable>()
    private var chatMemeberId: Set<String> = Set([])
    
    var workspace: WorkspacePresentationModel
    
    init(workspace: WorkspacePresentationModel) {
        self.workspace = workspace
    }
    
    @Published var member: [WorkspaceMemeberPresentationModel] = []
    @Published var dmlist: [DMRoomInfoPresentationModel] = []
    @Published var selectedChat: DMRoomInfoPresentationModel?
}

extension DMListModel: DMListActionProtocol {
    func getDMList() {
        do {
            let request = try DMRouter.dmlist(workspaceID: workspace.workspaceID).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: [DMRoomInfoResponse].self)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self]  value in
                    guard let self else { return }
                    
                    dmlist = value.map { $0.convertToModel() }.sorted { $0.createdAt < $1.createdAt }
                    chatMemeberId = Set(dmlist.map { $0.user.userID })
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
                request = try DMRouter.unreadChats(workSpaceID: workspace.workspaceID, roomID: roomID, cursorDate: date).makeRequest()
            } else {
                request = try DMRouter.unreadChats(workSpaceID: workspace.workspaceID, roomID: roomID).makeRequest()
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
    
    func getWorkspaceMemberList() {
        do {
            let request = try DMRouter.workspaceMember(workspaceID: workspace.workspaceID).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: [WorkspaceMemberResponse].self)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self]  value in
                    guard let self else { return }
                    
                    member = value.map { $0.convertToModel() }
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func setSelectedChat(opponentID: String) async {
        if chatMemeberId.contains(opponentID) {
            selectedChat = dmlist.filter { $0.user.userID == opponentID }[0]
        } else {
            await createDMChatRoom(opponentID: opponentID)
        }
        print(selectedChat)
    }
    
    private func createDMChatRoom(opponentID: String) async {
        do {
            let request = try DMRouter.createChat(workspaceID: workspace.workspaceID, opponentID: opponentID).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: DMRoomInfoResponse.self)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self]  value in
                    guard let self else { return }
                    
                    dmlist.append(value.convertToModel())
                    chatMemeberId.insert(opponentID)
                    selectedChat = value.convertToModel()
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
}
