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

    func viewOnAppear(_ workspaceID: String) {
        model?.fetchChennelList(workspaceID)
    }
    
    func onTapList() {
        model?.toggleAlert()
    }
}
