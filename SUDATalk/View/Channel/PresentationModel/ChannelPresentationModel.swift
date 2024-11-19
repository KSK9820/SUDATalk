//
//  ChannelPresentationModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import Foundation

struct ChannelPresentationModel {
    let channelID: String
    var name: String
    var description, coverImage: String?
    let ownerID, createdAt: String
    var channelMembers: [ChannelMemberPresentationModel]

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name, description, coverImage
        case ownerID = "owner_id"
        case createdAt, channelMembers
    }
    
    init(channelID: String, name: String, description: String?, coverImage: String?, ownerID: String, createdAt: String, channelMembers: [ChannelMemberPresentationModel]) {
        self.channelID = channelID
        self.name = name
        self.description = description
        self.coverImage = coverImage
        self.ownerID = ownerID
        self.createdAt = createdAt
        self.channelMembers = channelMembers
    }
    
    init() {
        self.channelID = ""
        self.name = ""
        self.description = ""
        self.coverImage = ""
        self.ownerID = ""
        self.createdAt = ""
        self.channelMembers = []
    }
}

struct ChannelMemberPresentationModel {
    let userID, email, nickname: String
    let profileImage: String?
    var profileImageData: Data?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}
