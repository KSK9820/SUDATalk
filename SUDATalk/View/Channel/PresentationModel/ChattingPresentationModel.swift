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

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case channelName
        case chatID = "chat_id"
        case content, createdAt, files, user
    }
    
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

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}
