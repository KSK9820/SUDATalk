//
//  ChannelEntity.swift
//  SUDATalk
//
//  Created by 박다현 on 11/27/24.
//

import Foundation
import RealmSwift

final class ChannelEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var channelID: String
    @Persisted var chat: List<ChannelChatEntity>
    @Persisted var name: String
    @Persisted var details: String?
    @Persisted var coverImage: String?
    @Persisted var ownerID: String
    @Persisted var createdAt: Date
    
    convenience init(channelID: String, chat: List<ChannelChatEntity> = List(), name: String, details: String? = nil, coverImage: String? = nil, ownerID: String, createdAt: Date) {
        self.init()
        self.channelID = channelID
        self.chat = chat
        self.name = name
        self.details = details
        self.coverImage = coverImage
        self.ownerID = ownerID
        self.createdAt = createdAt
    }
}
