//
//  DMRoomInfoResponse.swift
//  SUDATalk
//
//  Created by 김수경 on 11/22/24.
//

import Foundation

struct DMRoomInfoResponse: Decodable {
    let roomID: String
    let createdAt: String
    let user: DMUserResponse
    
    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case createdAt
        case user
    }
}

extension DMRoomInfoResponse {
    func convertToModel() -> DMRoomInfoPresentationModel {
        .init(roomID: self.roomID,
              createdAt: self.createdAt.convertToDate(),
              user: self.user.convertToModel())
    }
}
