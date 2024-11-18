//
//  DMSocketEvent.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation

struct DMSocketEvent: SocketEventProtocol {
    
    init(roomID: String) {
        self.nameSpace = .dm(roomID: roomID)
    }
    var url: URL {
        get throws {
            return try SocketEnvironment.message.asURL()
        }
    }
    var nameSpace: SocketNameSpace
    let events: [SocketEvent] = [.dm]
    let handler: SocketEventHandler = DMEventHandler()
}
