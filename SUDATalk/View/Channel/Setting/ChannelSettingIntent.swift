//
//  ChannelSettingIntent.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import Foundation

final class ChannelSettingIntent {
    private weak var model: ChannelSettingActionProtocol?

    init(model: ChannelSettingActionProtocol) {
        self.model = model
    }
}
