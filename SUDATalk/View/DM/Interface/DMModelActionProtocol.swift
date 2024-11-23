//
//  ModelActionProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

protocol DMModelActionProtocol: AnyObject {
    func setDMChatView()
    func sendMessage(query: DMChatSendPresentationModel)
    func disconnectSocket()
    func fetchImages(urls: [String], index: Int)
}
