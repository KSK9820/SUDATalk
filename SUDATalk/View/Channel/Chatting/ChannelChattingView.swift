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
            LazyVStack {
                ForEach(container.model.chatting.indices, id: \.self) { index in
                    let item = container.model.chatting[index]
    
                    ChatCellView(image: Image(systemName: "star"), userName: item.user.nickname, message: item.content, images: item.images, time: item.createdAt)
                        .task {
                            if !item.files.isEmpty {
                                container.intent.fetchImages(item.files, index: index)
                            }
                        }
                }
            }
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
        .onChange(of: container.model.uploadStatus) { _, newValue in
            if newValue {
                container.model.messageText = ""
                container.model.selectedImages = []
                container.model.uploadStatus = false
            }
        }
        .onAppear {
            if let channel = container.model.channel {
                container.intent.viewOnAppear(workspaceID: container.model.workspaceID,
                                              channelID: channel.channelID,
                                              date: "2024-11-04T08:11:07.252Z")
            }
        }
    }
}

extension ChannelChattingView {
    static func build(_ channel: ChannelListPresentationModel, workspaceID: String) -> some View {
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
