//
//  ChannelResponse.swift
//  SUDATalk
//
//  Created by 박다현 on 11/10/24.
//

import Foundation

struct ChannelResponse: Decodable {
    let channel_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let createdAt: String
}
