//
//  CreateChannelIntent.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import Foundation

final class CreateChannelIntent {
    private weak var model: CreateChannelActionsProtocol?

    init(model: CreateChannelActionsProtocol) {
        self.model = model
    }
    
    func createChannel(_ workspaceID: String) {}
}
