//
//  WorkspaceRouter.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import Foundation

enum WorkspaceRouter {
    case workspaceList
    case fetchImage(url: String)
}

extension WorkspaceRouter {
    func makeRequest() throws -> URLRequest {
        switch self {
        case .workspaceList:
            return try EndPoint(
                method: .get,
                path: ["workspaces"],
                header: EndPointHeader.authorization.header
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
    
    func makeURL() throws -> URL {
        switch self {
        case .workspaceList:
            return try EndPoint(
                method: .get,
                path: ["workspaces"],
                header: EndPointHeader.authorization.header
            ).asURL()
        case .fetchImage(let url):
            let boundary = "Boundary-\(UUID().uuidString)"
            return try EndPoint(
                method: .get,
                path: url.split(separator: "/").map { String($0) },
                header: EndPointHeader.multipartType(boundary: boundary).header
            ).asURL()
        }
    }
}
