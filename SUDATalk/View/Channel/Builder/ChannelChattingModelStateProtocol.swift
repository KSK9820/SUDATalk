//
//  ChannelChattingModelStateProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import SwiftUI

protocol ChannelChattingModelStateProtocol { 
    var workspaceID: String { get }
    var channel: ChannelList? { get }
    var messageText: String { get set }
    var selectedImages: [UIImage] { get set }
}
