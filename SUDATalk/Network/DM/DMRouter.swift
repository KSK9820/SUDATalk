//
//  DMRouter.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

enum DMRouter {
    case chats(workspaceID: String, roomID: String, body: DMChatQuery)
}

extension DMRouter {
    func makeRequest() throws -> URLRequest {
        switch self {
        case .chats(let workspaceID, let roomID, let body):
            return try EndPoint(
                method: .post,
                path: ["workspaces", workspaceID, "dms", roomID, "chats"],
                header: EndPointHeader.multipartform.header,
                body: body,
                multipartFormData: body.converTo()
            ).asURLRequest()
        }
    }
}