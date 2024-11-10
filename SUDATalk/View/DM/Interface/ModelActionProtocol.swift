//
//  ModelActionProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

protocol ModelActionProtocol: AnyObject {
    func sendMessage(query: DMChatQuery)
}
