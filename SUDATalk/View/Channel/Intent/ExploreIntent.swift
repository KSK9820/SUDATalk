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

    func viewOnAppear() {
        model?.fetchChennelList("e048cdee-a6dc-40bf-8dd2-402b56e5587d")
    }
    
    func onTapList() {
        model?.toggleAlert()
    }
}
