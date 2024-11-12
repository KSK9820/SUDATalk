//
//  CreateChannelActionsProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import Foundation

protocol CreateChannelActionsProtocol: AnyObject {
    func createChannel(_ workspaceID: String, input: ChannelInput) 
}
