//
//  UserRouter.swift
//  SUDATalk
//
//  Created by 김수경 on 10/31/24.
//

import Foundation

enum UserRouter {
    case login(query: Encodable)
}

extension UserRouter {
    func makeRequest() throws -> URLRequest {
        switch self {
        case .login(let login):
            return try EndPoint(
                method: .post,
                path: ["users", "login"],
                header: EndPointHeader.nonAuthorization.header,
                body: login
            ).asURLRequest()
        }
    }
}
