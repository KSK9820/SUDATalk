//
//  DMChatView.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import SwiftUI

struct DMChatView<Model: ModelStateProtocol & ModelActionProtocol>: View {
    @StateObject private var container: InterfaceContainer<DMChatIntentHandler, Model>
    
    var body: some View {
        Button("메세지 보내기") {
            container.intent.handle(intent: .sendMessage(query: DMChatQuery(content: "hi")))
        }
    }
}

extension DMChatView {
    static func build() -> some View {
        let model = DMChatModel()
        let intent = DMChatIntentHandler(model: model)
        let container = InterfaceContainer(
            intent: intent,
            model: model,
            modelChangePublisher: model.objectWillChange
        )
        
        return DMChatView<DMChatModel>(container: container)
    }
}
