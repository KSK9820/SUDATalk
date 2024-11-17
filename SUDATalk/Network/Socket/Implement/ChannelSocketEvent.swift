//
//  ChannelSocketEvent.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation

struct ChannelSocketEvent: SocketEventProtocol {
    init(roomID: String) {
        self.nameSpace = .channel(roomID: roomID)
    }
    
    var url: URL {
        get throws {
            return try SocketEnvironment.message.asURL()
        }
    }
    var nameSpace: SocketNameSpace
    let events: [SocketEvent] = [.channel]
    let handler: SocketEventHandler = ChannelEventHandler()
}
