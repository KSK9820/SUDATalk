//
//  DMUserResponse.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

struct DMUserResponse: Decodable {
    let userID, email, nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}

extension DMUserResponse {
    func toModel() -> DMUserPresentationModel {
        .init(userID: self.userID,
              email: self.email,
              nickname: self.nickname,
              profileImage: self.profileImage)
    }
}
