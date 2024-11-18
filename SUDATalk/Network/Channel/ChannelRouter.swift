//
//  ChannelRouter.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import UIKit

enum ChannelRouter {
    case channelList(param: String)
    case myChannelList(param: String)
    case sendChat(workspaceID: String, channelID: String, query: ChatQuery)
    case fetchChat(workspaceID: String, channelID: String, date: String)
    case fetchImage(url: String)
    case createChannel(workspaceID: String, query: ChannelQuery)
    case channel(workspaceID: String, channelID: String)
    case exitChannel(workspaceID: String, channelID: String)
}

extension ChannelRouter {
    func makeRequest() throws -> URLRequest {
        switch self {
        case .channelList(let param):
            return try EndPoint(
                method: .get,
                path: ["workspaces", param, "channels"],
                header: EndPointHeader.authorization.header
            ).asURLRequest()
        case .myChannelList(let param):
            return try EndPoint(
                method: .get,
                path: ["workspaces", param, "my-channels"],
                header: EndPointHeader.authorization.header
            ).asURLRequest()
        case .sendChat(let workspaceID, let channelID, let query):
            let boundary = "Boundary-\(UUID().uuidString)"
            let body = MultipartFormDataBuilder.createMultipartBody(query: query, boundary: boundary)

            return try EndPoint(
                method: .post,
                path: ["workspaces", workspaceID, "channels", channelID, "chats"],
                header: EndPointHeader.multipartType(boundary: boundary).header,
                multipartBody: body
            ).asURLRequest()
        case .fetchChat(let workspaceID, let channelID, let date):
            return try EndPoint(
                method: .get,
                path: ["workspaces", workspaceID, "channels", channelID, "chats"],
                header: EndPointHeader.authorization.header,
                parameter: [URLQueryItem(name: "cursor_date", value: date)]
            ).asURLRequest()
        case .fetchImage(let url):
            let arrUrl = url.split(separator: "/").map{ String($0) }
            
            return try EndPoint(
                method: .get,
                path: arrUrl,
                header: EndPointHeader.multipartType(boundary: "Boundary-\(UUID().uuidString)").header
            ).asURLRequest()
        case .createChannel(let workspaceID, let query):
            let boundary = "Boundary-\(UUID().uuidString)"
            let body = MultipartFormDataBuilder.createMultipartBody(query: query, boundary: boundary)
            
            return try EndPoint(
                method: .post,
                path: ["workspaces", workspaceID, "channels"],
                header: EndPointHeader.multipartType(boundary: boundary).header,
                multipartBody: body
            ).asURLRequest()
        case .channel(let workspaceID, let channelID):
            return try EndPoint(
                method: .get,
                path: ["workspaces", workspaceID, "channels", channelID],
                header: EndPointHeader.authorization.header
            ).asURLRequest()
        case .exitChannel(let workspaceID, let channelID):
            return try EndPoint(
                method: .get,
                path: ["workspaces", workspaceID, "channels", channelID, "exit"],
                header: EndPointHeader.authorization.header
            ).asURLRequest()
        }
    }
}
