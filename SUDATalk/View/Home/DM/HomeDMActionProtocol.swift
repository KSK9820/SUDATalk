//
//  HomeDMActionProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 12/6/24.
//

import Foundation

protocol HomeDMActionProtocol: AnyObject {
    func getDMList()
    func fetchThumbnail(_ url: String, idx: Int)
    func getUnreadChatCount(idx: Int, roomID: String)
}
