//
//  SocketNameSpace.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation

enum SocketNameSpace: CustomStringConvertible {
    case channel(roomID: String)
    case dm(roomID: String)
}

extension SocketNameSpace {
    var description: String {
        switch self {
        case .channel(let roomID):
            return "/ws-channel-\(roomID)"
        case .dm(let roomID):
            return "/ws-dm-\(roomID)"
        }
    }
}
