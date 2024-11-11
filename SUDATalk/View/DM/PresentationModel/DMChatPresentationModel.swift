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
}
