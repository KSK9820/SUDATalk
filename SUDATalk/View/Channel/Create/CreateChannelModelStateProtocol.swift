//
//  CreateChannelModelStateProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import Foundation

protocol CreateChannelModelStateProtocol {
    var channelName: String { get set }
    var description: String { get set }
    var activeSubmit: Bool { get set }
}
