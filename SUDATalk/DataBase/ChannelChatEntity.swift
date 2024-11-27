//
//  ChannelChatEntity.swift
//  SUDATalk
//
//  Created by 박다현 on 11/6/24.
//

import Foundation
import RealmSwift

final class ChannelChatEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var chatID: String
    @Persisted var channelID: String
    @Persisted var channelName: String
    @Persisted var content: String?
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
    @Persisted var user: UserEntity?
    
    convenience init(channelID: String, channelName: String, chatID: String, content: String, createdAt: Date, files: List<String> = List<String>(), user: UserEntity) {
        self.init()
        self.channelID = channelID
        self.channelName = channelName
        self.chatID = chatID
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }

    func convertToModel() -> ChattingPresentationModel {
        .init(channelID: channelID, channelName: channelName, chatID: chatID, content: content ?? "", createdAt: createdAt, files: Array(files), user: user?.convertToModel() ?? ChatUserPresentationModel(userID: "", email: "", nickname: "", profileImageUrl: nil, profileImageData: Data()), images: [])
    }
}
