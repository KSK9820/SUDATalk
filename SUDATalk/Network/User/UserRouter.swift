//
//  UserRouter.swift
//  SUDATalk
//
//  Created by 김수경 on 10/31/24.
//

import Foundation

enum UserRouter {
    case login(query: Encodable)
    case refresh
    case fetchImage(url: String)
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
        case .refresh:
            return try EndPoint(
                method: .get,
                path: ["auth", "refresh"],
                header: EndPointHeader.refreshToken.header
            ).asURLRequest()
        case .fetchImage(let url):
            let boundary = "Boundary-\(UUID().uuidString)"
            return try EndPoint(
                method: .get,
                path: url.split(separator: "/").map { String($0) },
                header: EndPointHeader.multipartType(boundary: boundary).header
            ).asURLRequest()
        }
    }
}
