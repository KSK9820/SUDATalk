//
//  WebSocketManager.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import Combine
import Foundation

import SocketIO

final class WebSocketManager {
    private var manager:SocketManager
    private var socket:SocketIOClient
    var chatData = PassthroughSubject<SendChatResponse, Never>()

    init(channelID: String){
        let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
        let url = URL(string: "http://\(baseURL):39093")!
        
        manager = SocketManager(socketURL: url) 
        socket = manager.socket(forNamespace: "/ws-channel-\(channelID)")
        socket.on(clientEvent: .connect) { _, _ in
            print("socket connected")
        }
        socket.on(clientEvent: .disconnect) { _, _ in
            print("SOCKET IS DISCONNECTED")
        }
        
        socket.on("channel") { [weak self] dataArray, _ in
            guard let firstItem = dataArray.first as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: firstItem, options: [])
                let decodedData = try JSONDecoder().decode(SendChatResponse.self, from: jsonData)
                
                self?.chatData.send(decodedData)
            } catch {
                print("Error converting to Data or decoding:", error)
            }
        }
    }
    
    func establishConnect() {
        socket.connect()
    }
    
    func closeConnect() {
        socket.disconnect()
    }
}
