//
//  ChannelChattingView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import SwiftUI

struct ChannelChattingView: View {
    @StateObject private var container: Container<ChannelChattingIntent, ChannelChattingModelStateProtocol>
    
    private func binding(for keyPath: WritableKeyPath<ChannelChattingModelStateProtocol, String>) -> Binding<String> {
        Binding(
            get: { container.model[keyPath: keyPath] },
            set: { newValue in
                container.model.messageText = newValue
            }
        )
    }
    
    private func binding(for keyPath: WritableKeyPath<ChannelChattingModelStateProtocol, [UIImage]>) -> Binding<[UIImage]> {
        Binding(
            get: { container.model[keyPath: keyPath] },
            set: { newValue in
                container.model.selectedImages = newValue
            }
        )
    }
    
    var body: some View {
        ScrollView {
            ChatCellView(image: Image(systemName: "star"), userName: "닉네임", message: "메세지입니다.", images: [Image("testImage"), Image("testImage"), Image("testImage"), Image("testImage"), Image("testImage")], time: "2024.11.10")
            ChatCellView(image: Image(systemName: "star"), userName: "닉네임", message: "메세지입니다.", images: [Image("testImage")], time: "2024.11.10")
            ChatCellView(image: Image(systemName: "star"), userName: "닉네임", message: "메세지입니다.", images: [Image("testImage"), Image("testImage")], time: "2024.11.10")
        }
        
        Spacer()
        
        ChatInputView(messageText: binding(for: \.messageText), selectedImages: binding(for: \.selectedImages), sendButtonTap: {
            let query = ChatQuery(content: container.model.messageText, files: container.model.selectedImages)
            
            if let channel = container.model.channel {
                container.intent.sendMessage(workspaceID: container.model.workspaceID,
                                             channelID: channel.channelID,
                                             query: query)
            }
        })
        .navigationTitle(container.model.channel?.name ?? "")
    }
}

extension ChannelChattingView {
    static func build(_ channel: ChannelList, workspaceID: String) -> some View {
        let model = ChannelChattingModel()
        let intent = ChannelChattingIntent(model: model)
        
        model.workspaceID = workspaceID
        model.channel = channel
        
        let container = Container(
            intent: intent,
            model: model as ChannelChattingModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return ChannelChattingView(container: container)
    }
}
