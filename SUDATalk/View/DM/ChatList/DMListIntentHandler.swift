//
//  DMListIntentHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import Foundation

final class DMListIntentHandler: IntentProtocol {
    private var model: DMListActionProtocol
    typealias Intent = DMListIntent
    
    init(model: DMListActionProtocol) {
        self.model = model
    }
    
    func handle(intent: DMListIntent) {
        switch intent {
        case .getDMList:
            model.getDMList()
        case .getWorkspaceMember:
            model.getWorkspaceMemberList()
        case .getUnreadChat(let idx, let roomID):
            model.getUnreadChatCount(idx: idx, roomID: roomID)
        case .selectedMember(let opponentID):
            Task {
                await model.setSelectedChat(opponentID: opponentID)
            }
        case .getProfileImage(let url, let idx):
            model.fetchThumbnail(url, idx: idx)
        }
    }
}

enum DMListIntent: IntentType {
    case getDMList
    case getWorkspaceMember
    case getUnreadChat(idx: Int, roomID: String)
    case selectedMember(opponentID: String)
    case getProfileImage(url: String, idx: Int)
}
