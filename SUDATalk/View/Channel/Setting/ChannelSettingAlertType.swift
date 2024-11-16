//
//  ChannelSettingAlertType.swift
//  SUDATalk
//
//  Created by 박다현 on 11/16/24.
//

import Foundation

enum ChannelSettingAlertType: String, Identifiable {
    case exitChannel
    case editChannel
    case changeAdmin
    case deleteChannel
    
    var id: String {
        return self.rawValue
    }
    
    func primaryAction(container: Container<ChannelSettingIntent, ChannelSettingModelStateProtocol>) -> () -> Void {
            switch self {
            case .exitChannel:
                return { container.intent.action(.exitChannel) }
            case .editChannel:
                return { container.intent.action(.editChannel) }
            case .changeAdmin:
                return { container.intent.action(.changeAdmin) }
            case .deleteChannel:
                return { container.intent.action(.deleteChannel) }
            }
        }
    
    var alertDetails: (title: String, message: String) {
        switch self {
        case .exitChannel:
            return (
                title: "채널에서 나가기",
                message: "정말로 채널을 나가시겠습니까?"
            )
        case .editChannel:
            return (
                title: "채널 편집",
                message: "채널을 편집하시겠습니까?"
            )
        case .changeAdmin:
            return (
                title: "채널 관리자 변경",
                message: "채널 관리자를 변경하시겠습니까?"
            )
        case .deleteChannel:
            return (
                title: "채널 삭제",
                message: "채널을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다."
            )
        }
    }
    
}
