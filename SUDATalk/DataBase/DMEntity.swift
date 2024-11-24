//
//  DMEntity.swift
//  SUDATalk
//
//  Created by 김수경 on 11/21/24.
//

import Foundation
import RealmSwift

final class DMEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var dmID: String
    @Persisted var roomID: String
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    @Persisted var user: UserEntity?
    
    convenience init(dmID: String, roomID: String, content: String?, createdAt: String, files: List<String> = List<String>(), user: UserEntity?) {
        self.init()
        self.dmID = dmID
        self.roomID = roomID
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
    
    func convertToModel() -> DMChatPresentationModel {
        .init(dmID: self.dmID,
              roomID: self.roomID,
              content: self.content,
              createdAt: self.createdAt.convertToDate(),
              files: Array(self.files),
              user: self.user?.convertToModel() ?? DMUserPresentationModel())
    }
}
