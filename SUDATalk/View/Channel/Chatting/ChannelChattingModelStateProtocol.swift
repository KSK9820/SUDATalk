//
//  ChannelChattingModelStateProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import SwiftUI

protocol ChannelChattingModelStateProtocol { 
    var workspaceID: String { get }
    var channel: ChannelListPresentationModel? { get }
    var chatting: [ChattingPresentationModel] { get set }
    var input: ChannelChatInputModel { get set }
    var myProfile: UserProfile { get }
}
