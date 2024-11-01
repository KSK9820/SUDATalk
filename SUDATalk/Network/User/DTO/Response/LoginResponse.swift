//
//  LoginResponse.swift
//  SUDATalk
//
//  Created by 박다현 on 10/31/24.
//

import Foundation

struct Login {
    
}

struct LoginResponse: Decodable {
    let user_id: String
    let email: String
    let nickname: String?
    let profileImage: String?
    let phone: String?
    let provider: String?
    let createdAt: String
    let token: Token
    
    func conver2Model() -> Login {
        
    }
}

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
}
