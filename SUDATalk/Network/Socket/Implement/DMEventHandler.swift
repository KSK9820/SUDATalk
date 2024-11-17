//
//  DMEventHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation

struct DMEventHandler: SocketEventHandler {
    private let decoder = JSONDecoder()
    
    func handler(event: SocketEvent, data: Data) {
        switch event {
        case .dm:
            receiveDMMessage(message: data)
        default:
            break
        }
    }
    
    private func receiveDMMessage(message data: Data) {
        do {
            let decodedData = try decoder.decode(DMChatResponse.self, from: data)
            print(decodedData)
        } catch {
            print(error)
        }
    }
}
