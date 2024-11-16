//
//  ChannelSettingButtonsView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/16/24.
//

import SwiftUI

struct ChannelSettingButtonsView: View {
    var isOwner: Bool
    var alertTypeHandler: (ChannelSettingAlertType) -> Void
    
    var body: some View {
        VStack {
            Text("채널에서 나가기")
                .wrapToBorderButton(Colors.textPrimary) {
                    alertTypeHandler(.exitChannel)
                }
            
            if isOwner {
                Text("채널 편집")
                    .wrapToBorderButton(Colors.textPrimary) {
                        alertTypeHandler(.editChannel)
                    }
                
                Text("채널 관리자 변경")
                    .wrapToBorderButton(Colors.textPrimary) {
                        alertTypeHandler(.changeAdmin)
                    }
                
                Text("채널 삭제")
                    .wrapToBorderButton(Colors.error) {
                        alertTypeHandler(.deleteChannel)
                    }
            }
        }
    }
}

