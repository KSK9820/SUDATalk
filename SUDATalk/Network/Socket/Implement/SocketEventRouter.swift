//
//  SocketEventRouter.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation

final class SocketEventRouter {
    private var handlers: [SocketEvent: SocketEventHandler] = [:]
    
    func register(handler: SocketEventHandler, for events: [SocketEvent]) {
        for event in events {
            handlers[event] = handler
        }
    }
    
    func handleEvent(_ event: SocketEvent, data: Data) -> Decodable? {
        return handlers[event]?.handler(event: event, data: data)
    }
}
