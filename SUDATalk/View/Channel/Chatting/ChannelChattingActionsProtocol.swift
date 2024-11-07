//
//  ChannelChattingActionsProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import Foundation

protocol ChannelChattingActionsProtocol: AnyObject {
    func viewOnAppear(workspaceID: String, channelID: String, date: String)
    func sendMessage(workspaceID: String, channelID: String, query: ChatQuery)
    func fetchImages(_ urls: [String], index: Int)
}