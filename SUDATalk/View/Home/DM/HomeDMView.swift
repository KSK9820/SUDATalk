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
        LazyVStack(spacing: 12) {
            ForEach(Array(container.model.dmlist.enumerated()), id: \.offset) { index, value in
                NavigationLink {
                    NavigationLazyView(DMChatView.build(value))
                } label: {
                    HomeDMListView(dm: value)
                        .task {
                            if let profileURL = value.user.profileImage {
                                if value.user.profileImageData == nil {
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
    
    private struct HomeDMListView: View {
        var dm: DMRoomInfoPresentationModel
        
        var body: some View {
            HStack(spacing: 12, content: {
                if let uiimage = dm.user.profileImageData {
                    Image(uiImage: uiimage)
                        .roundedImageStyle(width: 30, height: 30)
                } else {
                    Images.userDefaultImage
                        .roundedImageStyle(width: 30, height: 30)
                }
                
                Text(dm.user.nickname)
                    .bold()
                
                Spacer()
                
                if dm.unreadChat.count != 0 {
                    Text("\(dm.unreadChat.count)")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.primary)
                        )
                        .foregroundColor(.white)
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
