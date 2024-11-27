//
//  ChannelChattingView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import SwiftUI

struct ChannelChattingView: View {
    @StateObject private var container: Container<ChannelChattingIntent, ChannelChattingModelStateProtocol>
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        chattingListSection()
        
        Spacer()
        
        ChatInputView(messageText: container.binding(for: \.messageText), selectedImages: container.binding(for: \.selectedImages), sendButtonTap: {
            if let channel = container.model.channel {
                container.intent.action(.sendMessage(workspaceID: container.model.workspaceID,
                                                     channelID: channel.channelID,
                                                     content: container.model.messageText,
                                                     images: container.model.selectedImages))
            }
        })
        
        .navigationTitle(container.model.channel?.name ?? "")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ChannelSettingView.build(container.model.workspaceID,
                                             channelID: container.model.channel?.channelID ?? "")
                } label: {
                    Images.detail
                }
            }
        }
        .onAppear {
            if let channel = container.model.channel {
                container.intent.action(.viewOnAppear(workspaceID: container.model.workspaceID,
                                                      channelID: channel.channelID))
            }
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background, .inactive:
                container.intent.action(.appInactive)
            case .active:
                container.intent.action(.appActive)
            @unknown default:
                print("unknown default")
            }
        }
    }
    
    func chattingListSection() -> some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                LazyVStack {
                    ForEach(container.model.chatting.indices, id: \.self) { index in
                        let item = container.model.chatting[index]
                        let profileImage = UIImage(data: item.user.profileImageData ?? Data())
                            .map { Image(uiImage: $0) } ?? Images.userDefaultImage
                        
                        ChatCellView(image: profileImage, userName: item.user.nickname, message: item.content, images: item.images, time: item.createdAt.toMessageDate())
                            .task {
                                if let profileUrl = item.user.profileImageUrl, !profileUrl.isEmpty {
                                    container.intent.action(.fetchProfileImages(url: profileUrl, index: index))
                                }
                                
                                if !item.files.isEmpty {
                                    container.intent.action(.fetchImages(urls: item.files, index: index))
                                }
                            }
                    }
                }
            }
            .onAppear {
                scrollViewProxy.scrollTo(container.model.chatting.count-1, anchor: .bottom)
            }
            .onChange(of: container.model.chatting) { _ in
                withAnimation {
                    scrollViewProxy.scrollTo(container.model.chatting.count-1, anchor: .bottom)
                }
            }
        }
        .onTapGesture {
            container.intent.action(.onTapGesture)
        }
    }
}

extension ChannelChattingView {
    static func build(_ channel: ChannelListPresentationModel, workspaceID: String) -> some View {
        let model = ChannelChattingModel(socketManager: SocketIOManager(event: ChannelSocketEvent(roomID: channel.channelID)))
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
