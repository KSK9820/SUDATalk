//
//  SocketEventHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation

protocol SocketEventHandler {
    func handler(event: SocketEvent, data: Data) -> Decodable?
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T?
}

extension SocketEventHandler {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
}
