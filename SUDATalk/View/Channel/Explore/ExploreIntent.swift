//
//  ExploreIntent.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Foundation

final class ExploreIntent {
    private weak var model: ExploreActionsProtocol?

    init(model: ExploreActionsProtocol) {
        self.model = model
    }
}

extension ExploreIntent: ChannelIntentProtocol {
    enum Action {
        case viewOnAppear(_ workspaceID: String)
        case onTapList
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let workspaceID):
            model?.fetchChennelList(workspaceID)
        case .onTapList:
            model?.toggleAlert()
        }
    }
    
    func asyncAction(_ action: Action) async {}
}
