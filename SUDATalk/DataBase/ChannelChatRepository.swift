//
//  ChannelChatRepository.swift
//  SUDATalk
//
//  Created by 박다현 on 11/6/24.
//

import Foundation
import RealmSwift

final class ChannelChatRepository {
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
            let chatEntity = ChannelChatEntity(
                channelID: chat.channelID,
                channelName: chat.channelName,
                chatID: chat.chatID,
                content: chat.content ?? "",
                createdAt: chat.createdAt.convertToDate(),
                user: UserEntity(userID: chat.user.userID, email: chat.user.email, nickname: chat.user.nickname, profileImage: chat.user.profileImage)
            )
            
            chatEntity.files.append(objectsIn: chat.files)
            
            try realm.write {
                realm.add(chatEntity, update: .modified)
            }
        } catch {
            print("addChatting: \(error)")
        }
    }
    
    func fetchChatting(_ channelID: String) -> [ChattingPresentationModel] {
        let chatList = realm.objects(ChannelChatEntity.self).filter("channelID == %@", channelID)
        
        return chatList.map { $0.convertToModel() }
    }
    
    func deleteChatting(_ channelID: String) {
        do {
            let chatList = realm.objects(ChannelChatEntity.self).filter { $0.channelID == channelID }
            
            try realm.write {
                chatList.forEach {
                    guard let user = $0.user else { return }
                    realm.delete(user)
                }
                
                realm.delete(chatList)
            }
        } catch {
            print("fail to delete Chatting: \(error)")
        }
    }
}
