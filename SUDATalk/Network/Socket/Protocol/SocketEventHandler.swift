//
//  SocketEventHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 11/17/24.
//

import Foundation

protocol SocketEventHandler {
    func handler(event: SocketEvent, data: Data)
}
