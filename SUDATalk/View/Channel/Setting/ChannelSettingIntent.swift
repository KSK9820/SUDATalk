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

extension ChannelSettingIntent: ChannelIntentProtocol {
    enum Action {
        case viewOnAppear
        case fetchProfileImages(url: String, index: Int)
        case exitChannel
        case editChannel
        case changeAdmin
        case deleteChannel
        case edittedChannel(_ channel: ChannelListPresentationModel)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            model?.getChannelInfo()
        case .fetchProfileImages(let url, let index):
            model?.fetchProfileImages(url, index: index)
        case .exitChannel:
            model?.exitChannel()
        case .editChannel:
            model?.editChannel()
        case .changeAdmin:
            model?.changeAdmin()
        case .deleteChannel:
            model?.deleteChannel()
        case .edittedChannel(let channel):
            model?.updateChannel(channel)
        }
    }
    
    func asyncAction(_ action: Action) async {}
}
