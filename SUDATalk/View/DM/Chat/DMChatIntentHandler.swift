//
//  DMChatIntentHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

final class DMChatIntentHandler: IntentProtocol {
    private var model: DMChatModelActionProtocol
    typealias Intent = DMChatIntent
    
    init(model: DMChatModelActionProtocol) {
        self.model = model
    }
    
    func handle(intent: DMChatIntent) {
        switch intent {
        case .setDMChat:
            model.setDMChatView()
        case .sendMessage(let query):
            model.sendMessage(query: query)
        case .fetchImages(let urls, let index):
            Task {
                await model.fetchImages(urls: urls, index: index)
            }
        case .disconnectSocket:
            model.disconnectSocket()
        case .connectSocket:
            model.connectSocket()
        }
    }
}

enum DMChatIntent: IntentType {
    case setDMChat
    case sendMessage(query: DMChatSendPresentationModel)
    case fetchImages(urls: [String], index: Int)
    case disconnectSocket
    case connectSocket
}
