//
//  UnreadChatResponse.swift
//  SUDATalk
//
//  Created by 박다현 on 12/4/24.
//

import Foundation

struct UnreadChatResponse: Decodable {
    let channel_id: String
    let name: String
    let count: Int
}
