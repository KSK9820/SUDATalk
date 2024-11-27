//
//  LoginResponse.swift
//  SUDATalk
//
//  Created by 박다현 on 10/31/24.
//

import Foundation

struct LoginResponse: Decodable {
    let user_id: String
    let email: String
    let nickname: String?
    let profileImage: String?
    let phone: String?
    let provider: String?
    let createdAt: String
    let token: Token
}

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension LoginResponse {
    func convertToModel() -> UserProfile {
        .init(userID: self.user_id, email: self.email, nickname: self.nickname, profileImage: self.profileImage)
    }
}
