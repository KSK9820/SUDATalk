//
//  ChannelChattingActionsProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import UIKit

protocol ChannelChattingActionsProtocol: AnyObject {
    func setChattingData(workspaceID: String, channelID: String)
    func sendMessage(workspaceID: String, channelID: String, content: String, images: [UIImage])
    func fetchImages(_ urls: [String], index: Int)
    func fetchProfileImages(_ url: String, index: Int)
    func connectSocket()
    func disconnectSocket()
}
