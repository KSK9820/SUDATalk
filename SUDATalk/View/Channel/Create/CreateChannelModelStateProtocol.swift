//
//  CreateChannelModelStateProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import Foundation

protocol CreateChannelModelStateProtocol {
    var channelID: String? { get set }
    var channelName: String { get set }
    var description: String { get set }
    var activeSubmit: Bool { get set }
    var isEditMode: Bool { get set }
    var modifiedChannel: ChannelListPresentationModel? { get set }
}
