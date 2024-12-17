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
            Text("GroupChat에서 나가기")
                .wrapToBorderButton(Colors.textPrimary) {
                    if isOwner {
                        alertTypeHandler(.ownerExitChannel)
                    } else {
                        alertTypeHandler(.exitChannel)
                    }
                }
            
            if isOwner {
                Text("GroupChat 편집")
                    .wrapToBorderButton(Colors.textPrimary) {
                        alertTypeHandler(.editChannel)
                    }
                
                Text("GroupChat 관리자 변경")
                    .wrapToBorderButton(Colors.textPrimary) {
                        alertTypeHandler(.changeAdmin)
                    }
                
                Text("GroupChat 삭제")
                    .wrapToBorderButton(Colors.error) {
                        alertTypeHandler(.deleteChannel)
                    }
            }
        }
    }
}
