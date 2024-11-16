//
//  ChannelSettingButtonsView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/16/24.
//

import SwiftUI

struct ChannelSettingButtonsView: View {
    @State private var alertType: AlertType?
    @State private var alertMessage: String?
    var isOwner: Bool
    
    enum AlertType: String, Identifiable {
        case exitChannel
        case editChannel
        case changeAdmin
        case deleteChannel
        
        var id: String {
            return self.rawValue
        }
        
        func primaryAction() -> () -> Void {
                switch self {
                case .exitChannel:
                    return { print("채널에서 나가기 액션") }
                case .editChannel:
                    return { print("채널 편집 액션") }
                case .changeAdmin:
                    return { print("채널 관리자 변경 액션") }
                case .deleteChannel:
                    return { print("채널 삭제 액션") }
                }
            }
    }

    var body: some View {
        VStack {
            Text("채널에서 나가기")
                .wrapToBorderButton(Colors.textPrimary) {
                    alertType = .exitChannel
                    alertMessage = "채널을 나가면 더 이상 채팅을 할 수 없습니다."
                }
            
            if isOwner {
                Text("채널 편집")
                    .wrapToBorderButton(Colors.textPrimary) {
                        alertType = .editChannel
                        alertMessage = "채널을 편집하시겠습니까?"
                    }

                Text("채널 관리자 변경")
                    .wrapToBorderButton(Colors.textPrimary) {
                        alertType = .changeAdmin
                        alertMessage = "채널 관리자를 변경하시겠습니까?"
                    }

                Text("채널 삭제")
                    .wrapToBorderButton(Colors.error) {
                        alertType = .deleteChannel
                        alertMessage = "채널을 삭제하시겠습니까? 삭제된 채널은 복구할 수 없습니다."
                    }
            }
        }
        .alert(item: $alertType) { type in
            let title: String
            let message: String

            switch type {
            case .exitChannel:
                title = "채널에서 나가기"
                message = alertMessage ?? ""
            case .editChannel:
                title = "채널 편집"
                message = alertMessage ?? ""
            case .changeAdmin:
                title = "채널 관리자 변경"
                message = alertMessage ?? ""
            case .deleteChannel:
                title = "채널 삭제"
                message = alertMessage ?? ""
            }

            return Alert(
                title: Text(title),
                message: Text(message),
                primaryButton: .destructive(Text("확인"), action: type.primaryAction()),
                secondaryButton: .cancel()
            )
        }
    }
}

