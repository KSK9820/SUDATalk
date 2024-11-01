//
//  User.swift
//  SUDATalk
//
//  Created by 김수경 on 10/31/24.
//

import Foundation

enum User {
    case login(a: Encodable)
    
    func makeRequest() throws -> URLRequest {
        switch self {
        case .login(let login):
            return try EndPoint(
                method: .post,
                path: ["users", "login"],
                header: EndPointHeader.authorization.header,
                body: login
            ).asURLRequest()
        }
    }
}

struct LoginQuery: Encodable {
    let email: String
    let password: String
    let deviceToken: String
}
