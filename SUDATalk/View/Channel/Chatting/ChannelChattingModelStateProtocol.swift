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
    var messageText: String { get set }
    var selectedImages: [UIImage] { get set }
    var uploadStatus: Bool { get set }
    var chatting: [ChattingPresentationModel] { get set }
}