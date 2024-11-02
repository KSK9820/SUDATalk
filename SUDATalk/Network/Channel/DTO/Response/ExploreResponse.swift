//
//  ExploreResponse.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Foundation

struct ExploreResponse: Decodable {
    let channelID, name: String
    let description, coverImage: String?
    let ownerID, createdAt: String

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name, description, coverImage
        case ownerID = "owner_id"
        case createdAt
    }
    
    func convertToModel() -> ChannelList {
        .init(channelID: channelID, name: name, description: description, coverImage: coverImage, ownerID: ownerID, createdAt: createdAt)
    }
}
