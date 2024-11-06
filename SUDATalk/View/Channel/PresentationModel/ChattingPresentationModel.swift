//
//  ChattingPresentationModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import Foundation

struct ChattingPresentationModel {
    let channelID, channelName, chatID, content: String
    let createdAt: String
    let files: [String]
    let user: ChatUserPresentationModel
    var images: [Data]

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case channelName
        case chatID = "chat_id"
        case content, createdAt, files, user
    }
}

struct ChatUserPresentationModel: Decodable {
    let userID, email, nickname: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}
