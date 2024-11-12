//
//  ChattingRepository.swift
//  SUDATalk
//
//  Created by 박다현 on 11/6/24.
//

import Foundation
import RealmSwift

final class ChattingRepository {
    private let realm: Realm
    
    init?() {
        do {
            self.realm = try Realm()
            print(realm.configuration.fileURL ?? "")
        } catch let error as NSError {
            print("Failed to initialize Realm with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func addChatting(_ chat: SendChatResponse) {
        do {
            let chatEntity = ChattingEntity(
                channelID: chat.channelID,
                channelName: chat.channelName,
                chatID: chat.chatID,
                content: chat.content,
                createdAt: chat.createdAt,
                user: UserEntity(userID: chat.user.userID, email: chat.user.email, nickname: chat.user.nickname, profileImage: chat.user.profileImage)
            )
            
            chatEntity.files.append(objectsIn: chat.files)
            
            try realm.write {
                realm.add(chatEntity)
            }
        } catch {
            print("addChatting: \(error)")
        }
    }
    
    func fetchChatting(_ channelID: String) -> [ChattingPresentationModel] {
        let chatList = realm.objects(ChattingEntity.self).filter{ $0.channelID == channelID }
        
        return chatList.map { $0.convertToModel() }
    }
}
