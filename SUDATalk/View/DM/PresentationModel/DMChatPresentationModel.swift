//
//  DMChatPresentationModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation
import SwiftUI
import RealmSwift

struct DMChatPresentationModel {
    let dmID, roomID: String
    let content: String?
    let createdAt: Date
    let files: [String]
    var dataFiles: [Data?]
    let user: DMUserPresentationModel
    
    var convertedImage: [Image?] {
        var images = [Image]()
        
        dataFiles.forEach { data in
            if let dataFile = data,
               let image = UIImage(data: dataFile) {
                images.append(Image(uiImage: image))
            }
        }
        
        return images
    }
    
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
        let entity = DMEntity(dmID: self.dmID,
                              roomID: self.roomID,
                              content: self.content,
                              createdAt: self.createdAt,
                              user: self.user.toEntity())
        
        entity.files.append(objectsIn: self.files)
        
        return entity
    }
}
