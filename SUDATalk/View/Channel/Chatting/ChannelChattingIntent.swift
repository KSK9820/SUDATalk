//
//  ChannelChattingIntent.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import UIKit

final class ChannelChattingIntent {
    private weak var model: ChannelChattingActionsProtocol?

    init(model: ChannelChattingActionsProtocol) {
        self.model = model
    }
    
    func viewOnAppear(workspaceID: String, channelID: String, date: String) {
        model?.viewOnAppear(workspaceID: workspaceID, channelID: channelID, date: date)
    }
    
    func sendMessage(workspaceID: String, channelID: String, content: String, images: [UIImage]) {
        model?.sendMessage(workspaceID: workspaceID, channelID: channelID, content: content, images: images)
    }
    
    func fetchImages(_ urls: [String], index: Int) {
        model?.fetchImages(urls, index: index)
    }
}
