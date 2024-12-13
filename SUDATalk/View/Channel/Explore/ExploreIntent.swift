//
//  ExploreIntent.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Foundation

final class ExploreIntent {
    private weak var model: ExploreActionsProtocol?

    init(model: ExploreActionsProtocol) {
        self.model = model
    }
}

extension ExploreIntent: ChannelIntentProtocol {
    enum Action {
        case viewOnAppear(_ workspaceID: String)
        case onTapList
        case getUnreadChat(idx: Int, channelID: String)
        case resetUnreadChat(idx: Int)
        case fetchRoomImage(url: String, idx: Int)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let workspaceID):
            model?.fetchChennelList(workspaceID)
        case .onTapList:
            model?.toggleAlert()
        case .getUnreadChat(let idx, let channelID):
            model?.getUnreadChatCount(idx: idx, channelID: channelID)
        case .resetUnreadChat(let idx):
            model?.resetUnreadChatCount(idx: idx)
        case .fetchRoomImage(let url, let idx):
            model?.fetchThumbnail(url, idx: idx)
        }
    }
}
