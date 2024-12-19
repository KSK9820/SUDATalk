//
//  DMChatView.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import SwiftUI

struct DMChatView: View {
    @StateObject private var container: Container<DMChatIntentHandler, DMChatModelStateProtocol>
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack {
            chattingListSection()
            
            Spacer()
            
            ChatInputView(
                messageText: container.binding(for: \.dmInput.content),
                selectedImages: container.binding(for: \.dmInput.files),
                sendButtonTap: {
                    container.intent.handle(intent: .sendMessage(query: container.model.dmInput))
                }
            )
        }
        .navigationTitle(container.model.dmRoomInfo.user.nickname)
        .navigationBarTitleDisplayMode(.inline)
        .wrapToBackButton()
        .onAppear {
            container.intent.handle(intent: .setDMChat)
        }
        .onDisappear {
            container.intent.handle(intent: .disconnectSocket)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background, .inactive:
                container.intent.handle(intent: .disconnectSocket)
            case .active:
                container.intent.handle(intent: .connectSocket)
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
                        let profileImage = item.user.userID == container.model.dmRoomInfo.user.userID ? container.model.opponentProfileImage ?? Images.userDefaultImage : container.model.myProfileImage
                        
                        ChatCellView(image: profileImage, userName: item.user.nickname, message: item.content, images: item.convertedImage, time: item.createdAt.toMessageDate())
                            .task {
                                if !item.files.isEmpty {
                                    container.intent.handle(intent: .fetchImages(urls: item.files, index: index))
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
        }
    }
}

extension DMChatView {
    static func build(_ roomInfo: DMRoomInfoPresentationModel) -> some View {
        let model = DMChatModel(roomInfo)
        let intent = DMChatIntentHandler(model: model)
        let container = Container(
            intent: intent,
            model: model as DMChatModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return DMChatView(container: container)
    }
}
