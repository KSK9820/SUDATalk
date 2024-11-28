//
//  ChannelChattingActionsProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import UIKit

protocol ChannelChattingActionsProtocol: AnyObject {
    func setChattingData(workspaceID: String, channelID: String)
    func sendMessage(workspaceID: String, channelID: String, input: ChannelChatInputModel)
    func fetchImages(_ urls: [String], index: Int) async
    func profileImage(userID: String, url: String, index: Int) async
    func connectSocket()
    func disconnectSocket()
    func dismissKeyboard()
}
