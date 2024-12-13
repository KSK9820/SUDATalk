//
//  DMListView.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import SwiftUI
import UIKit

struct DMListView: View {
    @StateObject private var container: Container<DMListIntentHandler, DMListModelStateProtocol>
    @State private var isNavigating = false
    
    var body: some View {
        VStack(alignment: .leading) {
            DMHeaderView(workspace: container.model.workspace)
            
            Divider()
                .padding(.vertical, 8)
            
            LazyHStack(spacing: 12) {
                ForEach(container.model.member, id: \.userID) { member in
                    DMMemeberListView(member)
                        .onTapGesture {
                            isNavigating = false
                            container.intent.handle(intent: .selectedMember(opponentID: member.userID))
                            isNavigating = true
                        }
                }
            }
            .navigationDestination(isPresented: $isNavigating) {
                if let chatRoom = container.model.selectedChat {
                    NavigationLazyView(DMChatView.build(chatRoom))
                }
            }
            .padding(20)
            .frame(maxHeight: 60)
            
            Divider()
                .padding(.vertical, 8)
            
            LazyVStack {
                ForEach(Array(container.model.dmlist.enumerated()), id: \.element.roomID) { index, dmRoom in
                    NavigationLink {
                        NavigationLazyView(DMChatView.build(dmRoom))
                    } label: {
                        DMChatRoomView(dmRoom)
                            .task {
                                container.intent.handle(intent: .getUnreadChat(idx: index, roomID: dmRoom.roomID))
                            }
                    }
                }
            }
            Spacer()
        }
        .task {
            container.intent.handle(intent: .getDMList)
            container.intent.handle(intent: .getWorkspaceMember)
        }
    }
    
    struct DMHeaderView: View {
        private var workspace: WorkspacePresentationModel
        
        init(workspace: WorkspacePresentationModel) {
            self.workspace = workspace
        }
        
        var body: some View {
            HStack {
                if let coverImageData = workspace.coverImageSwiftUI {
                    coverImageData
                        .roundedImageStyle(width: 30, height: 30)
                        .padding(.trailing, 8)
                }
                Text("Direct Message")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                if let userProfileData = UserDefaultsManager.shared.userProfile.profileImageData,
                   let userProfileImage = UIImage(data: userProfileData) {
                    Image(uiImage: userProfileImage)
                        .circleImageStyle(width: 30, height: 30)
                } else {
                    Images.userDefaultImage
                        .circleImageStyle(width: 30, height: 30)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    struct DMMemeberListView: View {
        private let member: WorkspaceMemeberPresentationModel
        
        init(_ member: WorkspaceMemeberPresentationModel) {
            self.member = member
        }
        
        var body: some View {
            VStack(alignment: .center, spacing: 4) {
                if let profileData = member.profileImagefile,
                   let profileImage = UIImage(data: profileData) {
                    Image(uiImage: profileImage)
                        .roundedImageStyle(width: 40, height: 40)
                } else {
                    Images.userDefaultImage
                        .roundedImageStyle(width: 40, height: 40)
                }
                Text(member.nickname)
            }
        }
    }
    
    struct DMChatRoomView: View {
        private let roomInfo: DMRoomInfoPresentationModel
        
        init(_ roomInfo: DMRoomInfoPresentationModel) {
            self.roomInfo = roomInfo
        }
        
        var body: some View {
            HStack {
                if let profileURI = roomInfo.user.profileImage,
                   let profileData = CacheManager.shared.loadFromCache(forKey: profileURI),
                   let profileImage = UIImage(data: profileData) {
                    Image(uiImage: profileImage)
                        .roundedImageStyle(width: 40, height: 40)
                        .padding(.trailing, 8)
                } else {
                    Images.userDefaultImage
                        .roundedImageStyle(width: 40, height: 40)
                        .padding(.trailing, 8)
                }
                
                VStack(alignment: .leading) {
                    Text(roomInfo.user.nickname)
                        .bold()
                    if let lastChat = roomInfo.unreadChat.last?.content {
                        Text(lastChat)
                    } else if let lastChat = roomInfo.lastChat?.content {
                        Text(lastChat)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    if let lastChat = roomInfo.unreadChat.last {
                        Text(lastChat.createdAt.toMessageDate())
                            .font(.callout)
                            .foregroundStyle(.gray)
                    } else if let lastChat = roomInfo.lastChat?.createdAt {
                        Text(lastChat.toMessageDate())
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                    
                    if roomInfo.unreadChat.count != 0 {
                        Text("\(roomInfo.unreadChat.count)")
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.primary)
                            )
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

extension DMListView {
    static func build(workspace: WorkspacePresentationModel) -> some View {
        let model = DMListModel(workspace: workspace)
        let intent = DMListIntentHandler(model: model)
        let container = Container(
            intent: intent,
            model: model as DMListModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return DMListView(container: container)
    }
}
