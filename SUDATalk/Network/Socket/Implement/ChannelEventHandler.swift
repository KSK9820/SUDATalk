//
//  ChannelEventHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation

struct ChannelEventHandler: SocketEventHandler {
    private let decoder = JSONDecoder()
    
    func handler(event: SocketEvent, data: Data) {
        switch event {
        case .channel:
            receiveChannelMessage(message: data)
        default:
            break
        }
    }
    
    private func receiveChannelMessage(message data: Data) {
        do {
            let decodedData = try decoder.decode(SendChatResponse.self, from: data)
            print(decodedData)
        } catch {
            print(error)
        }
    }
}
