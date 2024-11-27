//
//  ChannelListPresentationModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Foundation

struct ChannelListPresentationModel: Equatable {
    let channelID, name: String
    let description, coverImage: String?
    let ownerID: String
    let createdAt: Date
    var isMyChannel: Bool = false

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name, description, coverImage
        case ownerID = "owner_id"
        case createdAt
    }
    
    func convertToEntity() -> ChannelEntity {
        .init(channelID: channelID, name: name, details: description, coverImage: coverImage, ownerID: ownerID, createdAt: createdAt)
    }
}
