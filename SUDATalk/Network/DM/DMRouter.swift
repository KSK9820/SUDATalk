//
//  DMRouter.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

enum DMRouter {
    // MARK: - DMChat
    case chats(workspaceID: String, roomID: String, body: DMChatQuery)
    case unreadChats(workSpaceID: String, roomID: String, cursorDate: Date? = nil)
    case fetchImage(url: String)
    
    // MARK: - DMList
    case dmlist(workspaceID: String)
    case workspaceMember(workspaceID: String)
    case createChat(workspaceID: String, opponentID: String)
}

extension DMRouter {
    func makeRequest() throws -> URLRequest {
        switch self {
        case .chats(let workspaceID, let roomID, let query):
            let boundary = "Boundary-\(UUID().uuidString)"
            let body = MultipartFormDataBuilder.createMultipartBody(query: query, boundary: boundary)
            
            return try EndPoint(
                method: .post,
                path: ["workspaces", workspaceID, "dms", roomID, "chats"],
                header: EndPointHeader.multipartType(boundary: boundary).header,
                multipartBody: body
            ).asURLRequest()
        case .unreadChats(let workspaceID, let roomID, let cursorDate):
            if let cursorDate {
                return try EndPoint(
                    method: .get,
                    path: ["workspaces", workspaceID, "dms", roomID, "chats"],
                    header: EndPointHeader.authorization.header,
                    parameter: [URLQueryItem(name: "cursor_date", value: cursorDate.toiso8601String())]
                ).asURLRequest()
            } else {
                return try EndPoint(
                    method: .get,
                    path: ["workspaces", workspaceID, "dms", roomID, "chats"],
                    header: EndPointHeader.authorization.header
                ).asURLRequest()
            }
        case .fetchImage(let url):
            let boundary = "Boundary-\(UUID().uuidString)"
            return try EndPoint(
                method: .get,
                path: url.split(separator: "/").map { String($0) },
                header: EndPointHeader.multipartType(boundary: boundary).header
            ).asURLRequest()
        case .dmlist(let workspaceID):
            return try EndPoint(
                method: .get,
                path: ["workspaces", workspaceID, "dms"],
                header: EndPointHeader.authorization.header
            ).asURLRequest()
        case .workspaceMember(let workspaceID):
            return try EndPoint(
                method: .get,
                path: ["workspaces", workspaceID, "members"],
                header: EndPointHeader.authorization.header
            ).asURLRequest()
        case .createChat(let workspaceID, let opponentID):
            return try EndPoint(
                method: .post,
                path: ["workspaces", workspaceID, "dms"],
                header: EndPointHeader.authorization.header,
                body: CreateDMQuery(opponentID: opponentID)
            ).asURLRequest()
        }
    }
}
