//
//  DMChatPresentationModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation
import RealmSwift

struct DMChatPresentationModel {
    let dmID, roomID: String
    let content: String?
    let createdAt: Date
    let files: [String]
    var dataFiles: [Data?]
    let user: DMUserPresentationModel
    
    init() {
        self.dmID = ""
        self.roomID = ""
        self.content = nil
        self.createdAt = Date()
        self.files = []
        self.dataFiles = []
        self.user = DMUserPresentationModel()
    }
    
    init(dmID: String, roomID: String, content: String?, createdAt: Date, files: [String], user: DMUserPresentationModel) {
        self.dmID = dmID
        self.roomID = roomID
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.dataFiles = []
        self.user = user
    }
}

extension DMChatPresentationModel: Equatable {
    static func == (lhs: DMChatPresentationModel, rhs: DMChatPresentationModel) -> Bool {
        lhs.dmID == rhs.dmID
    }
}

extension DMChatPresentationModel {
    func toEntity() -> DMEntity {
        let imagefiles = List<String>()
           
        imagefiles.append(objectsIn: self.files)
        
        return DMEntity(dmID: self.dmID,
                        roomID: self.roomID,
                        content: self.content,
                        createdAt: self.createdAt.toString(style: .iso) ?? "",
                        files: imagefiles,
                        user: self.user.toEntity())
    }
}
