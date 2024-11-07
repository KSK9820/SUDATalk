//
//  ChannelList.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Foundation

struct ChannelList {
    let channelID, name: String
    let description, coverImage: String?
    let ownerID, createdAt: String
    var isMyChannel: Bool = false

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name, description, coverImage
        case ownerID = "owner_id"
        case createdAt
    }
}
