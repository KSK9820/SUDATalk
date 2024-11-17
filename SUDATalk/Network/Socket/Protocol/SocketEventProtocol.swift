//
//  SocketEventProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 11/16/24.
//

import Foundation

protocol SocketEventProtocol {
    var url: URL { get throws }
    var nameSpace: SocketNameSpace { get }
    var events: [SocketEvent] { get }
    var handler: SocketEventHandler { get }
}
