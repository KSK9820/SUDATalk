//
//  DMChatResponse.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

struct DMChatResponse: Decodable {
    let dmID, roomID, createdAt: String
    let content: String?
    let files: [String]?
    let user: DMUserResponse
    
    enum CodingKeys: String, CodingKey {
        case dmID = "dm_id"
        case roomID = "room_id"
        case content, createdAt, files, user
    }
}

extension DMChatResponse {
    func toModel() -> DMChatPresentationModel {
        .init(dmID: self.dmID,
              roomID: self.roomID,
              content: self.content,
              createdAt: Date(),
              files: self.files,
              user: self.user.toModel())
    }
}
