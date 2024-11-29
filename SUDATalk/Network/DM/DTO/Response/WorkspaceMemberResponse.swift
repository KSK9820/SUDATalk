//
//  WorkspaceMemberResponse.swift
//  SUDATalk
//
//  Created by 김수경 on 11/29/24.
//

import Foundation

struct WorkspaceMemberResponse: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nickname
        case profileImage
    }
}

extension WorkspaceMemberResponse {
    func convertToModel() -> WorkspaceMemeberPresentation {
        .init(userID: self.userID,
              email: self.email,
              nickname: self.nickname,
              profileImage: self.profileImage)
    }
}
