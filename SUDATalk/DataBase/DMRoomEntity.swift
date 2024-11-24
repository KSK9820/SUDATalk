//
//  DMRoomEntity.swift
//  SUDATalk
//
//  Created by 김수경 on 11/23/24.
//

import Foundation
import RealmSwift

final class DMRoomEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var roomID: String
    @Persisted var chat: List<DMEntity>
    
    convenience init(roomID: String, chat: List<DMEntity> = List()) {
        self.init()
        self.roomID = roomID
        self.chat = chat
    }
    
    func convertToModel() -> DMChatRoomPresentationModel {
        .init(roomID: self.roomID, chat: chat.map { $0.convertToModel() })
    }
}
