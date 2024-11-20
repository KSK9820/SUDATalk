//
//  SocketIOManager.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Combine
import Foundation
import SocketIO

final class SocketIOManager {
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    private let config: SocketEventProtocol
    private var messagePublisher = PassthroughSubject<Decodable, Error>()
    
    var publisher: AnyPublisher<Decodable, Error> {
        messagePublisher.eraseToAnyPublisher()
    }
    
    init(event: SocketEventProtocol) {
        self.config = event
        
        setupSocket()
    }
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    private func setupSocket() {
        do {
            let configuration = SocketIOClientConfiguration(arrayLiteral: .log(true), .compress)
    
            manager = try SocketManager(socketURL: config.url, config: configuration)
            socket = manager?.socket(forNamespace: config.nameSpace.description)

            setupSocketEvent()
        } catch {
            print(error)
        }
    }

    private func setupSocketEvent() {
        socket?.on(clientEvent: .connect) { _, _ in
            print("Socket Connected")
        }
        
        socket?.on(clientEvent: .disconnect) { _, _ in
            print("Socket Disconnected")
        }

        for event in config.events {
            socket?.on(event.rawValue, callback: { [weak self] data, _ in
                guard let self else { return }
                guard let rawData = data.first as? [String: Any],
                      let jsonData = try? JSONSerialization.data(withJSONObject: rawData) else {
                    
                    return messagePublisher.send(completion: .failure(NetworkError.encoding))
                }
                
                if let decodedData = config.handler.onEvent(event: event, data: jsonData) {
                    messagePublisher.send(decodedData)
                } else {
                    messagePublisher.send(completion: .failure(NetworkError.decoding))
                }
            })
        }
    }
}
