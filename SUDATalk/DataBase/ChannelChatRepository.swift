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
            //print(realm.configuration.fileURL ?? "")
        } catch let error as NSError {
            print("Failed to initialize Realm with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func createChannel(_ channel: ChannelListPresentationModel) {
        do {
            if realm.object(ofType: ChannelEntity.self, forPrimaryKey: channel.channelID) == nil {
                let channelListEntity = channel.convertToEntity()
                
                try realm.write {
                    realm.add(channelListEntity)
                }
            }
        } catch {
            print("Failed to create channel: \(error)")
        }
    }
    
    func createChannel(_ channel: ChannelEntity) {
        do {
            try realm.write {
                realm.add(channel)
            }
        } catch {
            print("Failed to create channel: \(error)")
        }
    }

    func addChannelChat(_ chat: ChattingPresentationModel) {
        do {
            var channelEntity: ChannelEntity
            if let channel = realm.object(ofType: ChannelEntity.self, forPrimaryKey: chat.channelID) {
                channelEntity = channel
            } else {
                let channel = ChannelEntity(channelID: chat.channelID, name: chat.channelName, ownerID: chat.user.userID, createdAt: chat.createdAt)
                channelEntity = channel
                createChannel(channelEntity)
            }
            let chatEntity = chat.convertToEntity()
            if !channelEntity.chat.contains(where: { $0.chatID == chatEntity.chatID }) {
                
                try realm.write {
                    realm.add(chatEntity, update: .modified)
                    channelEntity.chat.append(chatEntity)
                }
            }
        } catch {
            print("Failed to add channelChat into channel: \(error)")
        }
    }
    
    func fetchChatting(_ channelID: String) -> [ChattingPresentationModel] {
        guard let channel = realm.objects(ChannelEntity.self).filter("channelID == %@", channelID).first else {
            return []
        }
        
        return channel.chat.map { $0.convertToModel() }
    }
    
    func deleteChannel(_ channelID: String) {
        do {
            let channel = realm.objects(ChannelEntity.self).filter { $0.channelID == channelID }
            
            try realm.write {
                channel.forEach {
                    realm.delete($0.chat)
                }
                
                realm.delete(channel)
            }
        } catch {
            print("fail to delete Chatting: \(error)")
        }
    }
}
