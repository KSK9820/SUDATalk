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
    
    func createChannel(_ workspaceID: String, input: ChannelInputModel) {
        model?.createChannel(workspaceID, input: input)
    }
}

extension CreateChannelIntent: ChannelIntentProtocol {
    enum Action {
        case createChannel(_ workspaceID: String, input: ChannelInputModel)
        case editChannel(_ workspaceID: String, input: ChannelInputModel)
    }
    
    func action(_ action: Action) {
        switch action {
        case .createChannel(let workspaceID, let input):
            model?.createChannel(workspaceID, input: input)
        case .editChannel(let workspaceID, let input):
            model?.editChannel(workspaceID, input: input)
        }
    }
}
