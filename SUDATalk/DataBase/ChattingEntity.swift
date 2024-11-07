//
//  ChattingEntity.swift
//  SUDATalk
//
//  Created by 박다현 on 11/6/24.
//

import Foundation
import RealmSwift

final class ChattingEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var chatID: String
    @Persisted var channelID: String
    @Persisted var channelName: String
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    @Persisted var user: UserEntity?
    
    convenience init(channelID: String, channelName: String, chatID: String, content: String, createdAt: String, files: List<String> = List<String>(), user: UserEntity) {
        self.init()
        self.channelID = channelID
        self.channelName = channelName
        self.chatID = chatID
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}

final class UserEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var userID: String
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(userID: String, email: String, nickname: String, profileImage: String? = nil) {
        self.init()
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
