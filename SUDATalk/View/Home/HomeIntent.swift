//
//  HomeIntent.swift
//  SUDATalk
//
//  Created by 박다현 on 12/2/24.
//

import Foundation

final class HomeIntent {
    private weak var model: HomeActionsProtocol?

    init(model: HomeActionsProtocol) {
        self.model = model
    }
}

extension HomeIntent: ChannelIntentProtocol {
    enum Action {
        case getDMList
    }
    
    func action(_ action: Action) {
        switch action {
        case .getDMList:
            model?.getDMList()
        }
    }
}
