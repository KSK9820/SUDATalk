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
    
    var body: some View {
        VStack(alignment: .leading) {
            DMHeaderView(workspace: container.model.workspace)
            Divider()
                .padding(.vertical, 8)
            DMMemeberListView(container.model.member)
            Divider()
                .padding(.vertical, 8)
            LazyVStack {
                DMChatRoomView(roomInfo: DMRoomInfoPresentationModel(roomID: "dddd", createdAt: Date(), user: DMUserPresentationModel(userID: "", email: "", nickname: "ddddddd", profileImage: nil, profileImageData: nil)))
            }
            Spacer()
        }
    }
    
    struct DMHeaderView: View {
        private var workspace: WorkSpacePresentationModel
        
        init(workspace: WorkSpacePresentationModel) {
            self.workspace = workspace
        }
        
        var body: some View {
            HStack {
                workspace.coverImage
                    .roundedImageStyle(width: 30, height: 30)
                    .padding(.trailing, 8)
                    
                Text("Direct Message")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                if let userProfileData = UserDefaultsManager.shared.userProfile.profileImageData,
                   let userProfileImage = UIImage(data: userProfileData) {
                    Image(uiImage: userProfileImage)
                        .circleImageStyle(width: 30, height: 30)
                        .padding(.trailing, 20)
                } else {
                    Images.userDefaultImage
                        .circleImageStyle(width: 30, height: 30)
                        .padding(.trailing, 20)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    struct DMMemeberListView: View {
        private var memberList: [WorkspaceMemeberPresentation]
        
        init(_ memberList: [WorkspaceMemeberPresentation]) {
            self.memberList = memberList
        }
        
        var body: some View {
            LazyHStack(spacing: 12) {
                ForEach(memberList, id: \.userID) { member in
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
            .padding(20)
            .frame(maxHeight: 60)
        }
    }
    
    struct DMChatRoomView: View {
        private let roomInfo: DMRoomInfoPresentationModel
        
        init(roomInfo: DMRoomInfoPresentationModel) {
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
                    Text("last chat")
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("time")
                        .font(.callout)
                        .foregroundStyle(.gray)
                    Text("1")
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.green)
                        )
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

extension DMListView {
    static func build() -> some View {
        let model = DMListModel()
        let intent = DMListIntentHandler(model: model)
        let container = Container(
            intent: intent,
            model: model as DMListModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return DMListView(container: container)
    }
}
