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
    
    func viewOnAppear(workspaceID: String, channelID: String, date: String) {
        model?.viewOnAppear(workspaceID: workspaceID, channelID: channelID, date: date)
    }
    
    func sendMessage(workspaceID: String, channelID: String, query: ChatQuery) {
        model?.sendMessage(workspaceID: workspaceID, channelID: channelID, query: query)
    }
    
    func fetchImages(_ urls: [String], index: Int) {
        model?.fetchImages(urls, index: index)
    }
}
