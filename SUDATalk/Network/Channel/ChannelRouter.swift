//
//  ChannelRouter.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Foundation

enum ChannelRouter {
    case channel(param: String)
    case myChannel(param: String)
}

extension ChannelRouter {
    func makeRequest() throws -> URLRequest {
        switch self {
        case .channel(let param):
            return try EndPoint(
                method: .get,
                path: ["workspaces", param, "channels"],
                header: EndPointHeader.authorization.header
            ).asURLRequest()
        case .myChannel(param: let param):
            return try EndPoint(
                method: .get,
                path: ["workspaces", param, "my-channels"],
                header: EndPointHeader.authorization.header
            ).asURLRequest()
        }
    }
}
