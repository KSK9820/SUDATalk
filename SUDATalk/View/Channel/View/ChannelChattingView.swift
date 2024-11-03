//
//  ChannelChattingView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import SwiftUI

struct ChannelChattingView: View {
    @StateObject private var container: ExploreContainer<ExploreIntent, ExploreModelStateProtocol>
    
    var body: some View {
        Text("채팅화면")
    }
}

extension ChannelChattingView {
    static func build() -> some View {
        let model = ExploreModel()
        let intent = ExploreIntent(model: model)
        
        let container = ExploreContainer(
            intent: intent,
            model: model as ExploreModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return ChannelChattingView(container: container)
    }
}


