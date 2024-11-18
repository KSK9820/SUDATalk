//
//  SocketIOManager.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation
import SocketIO

final class SocketIOManager {
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    private let config: SocketEventProtocol
    private let eventRouter = SocketEventRouter()
    
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
            registerHandler()
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
                    // MARK: - Error 처리 필요함
                    print("Failed to convert data to JSON")
                    return
                }
                eventRouter.handleEvent(event, data: jsonData)
            })
        }
    }
    
    private func registerHandler() {
        eventRouter.register(handler: config.handler, for: config.events)
    }
}
