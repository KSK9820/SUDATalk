//
//  DMRoomInfoPresentationModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/23/24.
//

import Foundation

struct DMRoomInfoPresentationModel {
    let roomID: String
    let createdAt: Date
    var user: DMUserPresentationModel
    var unreadChat: [DMChatPresentationModel] = []
    var lastChat: DMChatPresentationModel?
    
    init(roomID: String, createdAt: Date, user: DMUserPresentationModel) {
        self.roomID = roomID
        self.createdAt = createdAt
        self.user = user
    }
}
