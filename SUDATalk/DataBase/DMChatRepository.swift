//
//  DMChatRepository.swift
//  SUDATalk
//
//  Created by 김수경 on 11/22/24.
//

import Foundation
import RealmSwift

final class DMChatRepository {
    private let realm: Realm
    
    init?() {
        do {
            self.realm = try Realm()
            print("**", realm.configuration.fileURL ?? "")
        } catch let error as NSError {
            print("Failed to initialize Realm with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func createDMChatRoom(roomID id: String) throws -> DMRoomEntity {
        let dmRoomEntity = DMRoomEntity(roomID: id)
        
        try realm.write {
            realm.add(dmRoomEntity)
        }
        
        return dmRoomEntity
    }

    func addDMChat(_ chat: DMChatRoomPresentationModel) {
        do {
            let dmRoomEntity: DMRoomEntity
            if let roomEntity = realm.object(ofType: DMRoomEntity.self, forPrimaryKey: chat.roomID) {
                dmRoomEntity = roomEntity
            } else {
                dmRoomEntity = try createDMChatRoom(roomID: chat.roomID)
            }
            
            try realm.write {
                for dmChat in chat.chat {
                    let dmEntity = dmChat.toEntity()
                    
                    realm.add(dmEntity, update: .modified)
                    dmRoomEntity.chat.append(dmEntity)
                }
            }
        } catch {
            print("Failed to add DMChat into DMRoom: \(error)")
        }
    }
    
    func readDMChat(_ roomID: String) -> [DMChatPresentationModel] {
        if let dmRoom = realm.objects(DMRoomEntity.self).filter("roomID == %@", roomID).first {
            return dmRoom.chat.map { $0.convertToModel() }
        }
        
        return []
    }
}
