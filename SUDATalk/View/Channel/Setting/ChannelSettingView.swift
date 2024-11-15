//
//  ChannelSettingView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import SwiftUI

struct ChannelSettingView: View {
    @StateObject private var container: Container<ChannelSettingIntent, ChannelSettingModelStateProtocol>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationTitle("채널 설정")
    }
}

extension ChannelSettingView {
    static func build() -> some View {
        let model = ChannelSettingModel()
        let intent = ChannelSettingIntent(model: model)
        
        let container = Container(
            intent: intent,
            model: model as ChannelSettingModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return ChannelSettingView(container: container)
    }
}
