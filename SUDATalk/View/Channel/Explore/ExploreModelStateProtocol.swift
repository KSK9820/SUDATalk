//
//  ExploreModelStateProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Foundation

protocol ExploreModelStateProtocol {
    var workspaceID: String { get }
    var channelList: [ChannelListPresentationModel] { get set }
    var showAlert: Bool { get set }
}
