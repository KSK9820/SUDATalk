//
//  ChattingPresentationModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import SwiftUI
import RealmSwift

struct ChattingPresentationModel {
    let channelID, channelName, chatID, content: String
    let createdAt: Date
    let files: [String]
    var user: ChatUserPresentationModel
    var images: [Image?]
    var checkImages: Set<String>

    func convertToEntity() -> ChannelChatEntity {
        let chatEntity = ChannelChatEntity(
            channelID: channelID,
            channelName: channelName,
            chatID: chatID,
            content: content,
            createdAt: createdAt,
            user: UserEntity(userID: user.userID, email: user.email, nickname: user.nickname, profileImage: user.profileImageUrl)
        )
        
        chatEntity.files.append(objectsIn: files)
        
        return chatEntity
    }
}

extension ChattingPresentationModel: Equatable {
    static func == (lhs: ChattingPresentationModel, rhs: ChattingPresentationModel) -> Bool {
        lhs.channelID == rhs.channelID
    }
}

struct ChatUserPresentationModel {
    let userID, email, nickname: String
    let profileImageUrl: String?
    var profileImage: Image?
}
