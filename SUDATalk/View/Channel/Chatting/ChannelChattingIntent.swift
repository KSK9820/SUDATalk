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
}

extension ChannelChattingIntent: ChannelIntentProtocol {
    enum Action {
        case viewOnAppear(workspaceID: String, channelID: String)
        case sendMessage(workspaceID: String, channelID: String, content: String, images: [UIImage])
        case fetchImages(urls: [String], index: Int)
        case fetchProfileImages(url: String, index: Int)
        case appActive
        case appInactive
        case onTapGesture
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let workspaceID, let channelID):
            model?.setChattingData(workspaceID: workspaceID, channelID: channelID)
        case .sendMessage(let workspaceID, let channelID, let content, let images):
            model?.sendMessage(workspaceID: workspaceID, channelID: channelID, content: content, images: images)
        case .fetchImages(let urls, let index):
            Task {
                await model?.fetchImages(urls, index: index)
            }
        case .fetchProfileImages(let url, let index):
            Task {
                await model?.fetchProfileImages(url, index: index)
            }
        case .appActive:
            model?.connectSocket()
        case .appInactive:
            model?.disconnectSocket()
        case .onTapGesture:
            model?.dismissKeyboard()
        }
    }
}
