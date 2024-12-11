//
//  SendChatResponse.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import Foundation

struct SendChatResponse: Decodable {
    let channelID, channelName, chatID: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: UserResponse

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case channelName
        case chatID = "chat_id"
        case content, createdAt, files, user
    }
    
    func convertToModel() -> ChattingPresentationModel {
        .init(channelID: channelID, channelName: channelName, chatID: chatID, content: content ?? "", createdAt: createdAt.convertToDate(), files: files, user: user.convertToModel(), images: [], checkImages: [])
    }
}

struct UserResponse: Decodable {
    let userID, email, nickname: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
    
    func convertToModel() -> ChatUserPresentationModel {
        .init(userID: userID, email: email, nickname: nickname, profileImageUrl: profileImage, profileImage: nil)
    }
}
