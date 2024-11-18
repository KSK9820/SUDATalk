//
//  ChannelSettingModelStateProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import Foundation

protocol ChannelSettingModelStateProtocol {
    var workspaceID: String { get }
    var channelID: String { get }
    var channel: ChannelPresentationModel { get }
    var goToList: Bool { get }
}
