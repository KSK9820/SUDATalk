//
//  DMEventHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation

struct DMEventHandler: SocketEventHandler {
    private let decoder = JSONDecoder()
    
    func onEvent(event: SocketEvent, data: Data) -> Decodable? {
        switch event {
        case .dm:
            return decode(DMChatResponse.self, from: data)
        default:
            return nil 
        }
    }
}
