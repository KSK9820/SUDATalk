//
//  HomeDMView.swift
//  SUDATalk
//
//  Created by 김수경 on 12/6/24.
//

import Combine
import SwiftUI

struct HomeDMView: View {
    @StateObject private var container: Container<HomeDMIntentHandler, HomeDMModelStateProtocol>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(container.model.dmlist.enumerated()), id: \.offset) { index, value in
                    NavigationLink {
                        NavigationLazyView(DMChatView.build(value))
                    } label: {
                        HomeDMListView(dm: value)
                            .task {
                                if let profileURL = value.user.profileImage {
                                    if value.user.profileSwiftUIImage == nil {
                                        container.intent.handle(intent: .getProfileImage(url: profileURL, idx: index))
                                        container.intent.handle(intent: .getUnreadChat(idx: index, roomID: value.roomID))
                                    }
                                }
                            }
                    }
                }
            }
            .task {
                container.intent.handle(intent: .getDMList)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private struct HomeDMListView: View {
        var dm: DMRoomInfoPresentationModel
        
        var body: some View {
            HStack(spacing: 12, content: {
                if let profileImage = dm.user.profileSwiftUIImage {
                    profileImage
                        .roundedImageStyle(width: 50, height: 50)
                } else {
                    Images.userDefaultImage
                        .roundedImageStyle(width: 50, height: 50)
                }

                Text(dm.user.nickname)
                    .bold()
                    .foregroundStyle(Colors.black)
                
                Spacer()
                
                if dm.unreadChat.count != 0 {
                    Text("\(dm.unreadChat.count)")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .textStyle(.body)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Colors.primary)
                        )
                        .foregroundStyle(Colors.white)
                }
            })
        }
    }
}

extension HomeDMView {
    static func build(workspace: String) -> some View {
        let model = HomeDMModel(workspace: workspace)
        let intent = HomeDMIntentHandler(model: model)
        let container = Container(
            intent: intent,
            model: model as HomeDMModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return HomeDMView(container: container)
    }
}
