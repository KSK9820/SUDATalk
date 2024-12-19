//
//  ChannelEventHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation

struct ChannelEventHandler: SocketEventHandler {
    private let decoder = JSONDecoder()
    
    func onEvent(event: SocketEvent, data: Data) -> Decodable? {
        switch event {
        case .channel:
            return decode(SendChatResponse.self, from: data)
        default:
            return nil
        }
    }
}
