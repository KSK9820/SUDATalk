//
//  ChannelChattingIntent.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import Foundation

final class ChannelChattingIntent {
    private weak var model: ChannelChattingActionsProtocol?

    init(model: ChannelChattingActionsProtocol) {
        self.model = model
    }
    
    func sendMessage(workspaceID: String, channelID: String, query: ChatQuery) {
        model?.sendMessage(workspaceID: workspaceID, channelID: channelID, query: query)
    }
}
