//
//  ChannelResponse.swift
//  SUDATalk
//
//  Created by 박다현 on 11/10/24.
//

import Foundation

struct ChannelListResponse: Decodable {
    let channel_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let createdAt: String
    
    func convertToModel() -> ChannelListPresentationModel {
        .init(channelID: channel_id, name: name, description: description, coverImage: coverImage, ownerID: owner_id, createdAt: createdAt)
    }
}
