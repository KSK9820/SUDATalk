//
//  DMListActionProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import Foundation

protocol DMListActionProtocol: AnyObject {
    func getDMList()
    func getWorkspaceMemberList()
    func getUnreadChatCount(idx: Int, roomID: String)
    func setSelectedChat(opponentID: String) async
}
