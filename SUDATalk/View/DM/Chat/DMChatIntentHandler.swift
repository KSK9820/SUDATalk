//
//  DMChatIntentHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

final class DMChatIntentHandler: IntentProtocol {
    private var model: ModelActionProtocol
    typealias Intent = DMChatIntent
    
    init(model: ModelActionProtocol) {
        self.model = model
    }
    
    func handle(intent: DMChatIntent) {
        switch intent {
        case .sendMessage(let query):
            model.sendMessage(query: query)
        }
    }
}

enum DMChatIntent: IntentType {
    case sendMessage(query: DMChatQuery)
}
