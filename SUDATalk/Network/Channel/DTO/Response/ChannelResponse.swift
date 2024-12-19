//
//  ChannelResponse.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import Foundation

struct ChannelResponse: Decodable {
    let channelID, name: String
    let description, coverImage: String?
    let ownerID, createdAt: String
    let channelMembers: [ChannelMember]

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name, description, coverImage
        case ownerID = "owner_id"
        case createdAt, channelMembers
    }
    
    func convertToModel() -> ChannelPresentationModel {
        let channelMembersModels = channelMembers.map { $0.convertToModel() }
        
        return .init(channelID: channelID, name: name, description: description, coverImage: coverImage, ownerID: ownerID, createdAt: createdAt, channelMembers: channelMembersModels)
    }
}

struct ChannelMember: Decodable {
    let userID, email, nickname: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
    
    func convertToModel() -> ChannelMemberPresentationModel {
        .init(userID: userID, email: email, nickname: nickname, profileImageURL: profileImage)
    }
}
