//
//  ChattingPresentationModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import Foundation

struct ChattingPresentationModel {
    let channelID, channelName, chatID, content: String
    let createdAt: Date
    let files: [String]
    var user: ChatUserPresentationModel
    var images: [Data?]

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case channelName
        case chatID = "chat_id"
        case content, createdAt, files, user
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
    var profileImageData: Data

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}
