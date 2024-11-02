//
//  ChannelExploreIntent.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Foundation

final class ChannelExploreIntent {

    // 1
    private weak var model: ListModelActionsProtocol?

    init(model: ListModelActionsProtocol) {
        self.model = model
    }

    func viewOnAppear() {
        model?.postData()
    }
}
