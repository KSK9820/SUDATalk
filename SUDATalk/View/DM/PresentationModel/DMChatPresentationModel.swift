//
//  DMChatPresentationModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

struct DMChatPresentationModel {
    let dmID, roomID: String
    let content: String?
    let createdAt: Date
    let files: [String]?
    let user: DMUserPresentationModel
    
    init() {
        self.dmID = ""
        self.roomID = ""
        self.content = nil
        self.createdAt = Date()
        self.files = nil
        self.user = DMUserPresentationModel()
    }
    
    init(dmID: String, roomID: String, content: String?, createdAt: Date, files: [String]?, user: DMUserPresentationModel) {
        self.dmID = dmID
        self.roomID = roomID
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}
