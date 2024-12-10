//
//  HomeDMIntentHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 12/6/24.
//

import Foundation

final class HomeDMIntentHandler: IntentProtocol {
    private var model: HomeDMActionProtocol
    typealias Intent = HomeDMIntent
    
    init(model: HomeDMActionProtocol) {
        self.model = model
    }
    
    func handle(intent: HomeDMIntent) {
        switch intent {
        case .getDMList:
            model.getDMList()
        case .getProfileImage(let url, let idx):
            model.fetchThumbnail(url, idx: idx)
        case .getUnreadChat(let idx, let roomID):
            model.getUnreadChatCount(idx: idx, roomID: roomID)
        }
    }
}

enum HomeDMIntent: IntentType {
    case getDMList
    case getProfileImage(url: String, idx: Int)
    case getUnreadChat(idx: Int, roomID: String)
}

