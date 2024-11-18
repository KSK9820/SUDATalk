//
//  ChannelSettingAlertType.swift
//  SUDATalk
//
//  Created by 박다현 on 11/16/24.
//

import Foundation

enum ChannelSettingAlertType: String, Identifiable {
    case ownerExitChannel
    case exitChannel
    case editChannel
    case changeAdmin
    case deleteChannel
    
    var id: String {
        return self.rawValue
    }
    
    func primaryAction(container: Container<ChannelSettingIntent, ChannelSettingModelStateProtocol>) -> () -> Void {
            switch self {
            case .ownerExitChannel:
                return {}
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
    
    var alertDetails: (title: String, message: String, cancelButton: Bool) {
        switch self {
        case .ownerExitChannel:
            return (
                title: "채널에서 나가기",
                message: "회원님은 채널 관리자입니다. 채널 관리자를 다른 멤버로 변경 후 나갈 수 있습니다.",
                cancelButton: false
            )
        case .exitChannel:
            return (
                title: "채널에서 나가기",
                message: "정말로 채널을 나가시겠습니까?",
                cancelButton: true
            )
        case .editChannel:
            return (
                title: "채널 편집",
                message: "채널을 편집하시겠습니까?",
                cancelButton: true
            )
        case .changeAdmin:
            return (
                title: "채널 관리자 변경",
                message: "채널 관리자를 변경하시겠습니까?",
                cancelButton: true
            )
        case .deleteChannel:
            return (
                title: "채널 삭제",
                message: "채널을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.",
                cancelButton: true
            )
        }
    }
    
}
