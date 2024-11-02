//
//  ExploreModelStateProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Foundation

protocol ExploreModelStateProtocol {
    var channelList: [ChannelList] { get set }
    var showAlert: Bool { get set }
}
