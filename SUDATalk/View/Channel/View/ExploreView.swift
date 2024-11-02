//
//  ChannelExploreView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import SwiftUI

struct ChannelExploreView: View {
    @StateObject private var container: ChannelExploreContainer<ChannelExploreIntent, ChannelExploreStateProtocol>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension ChannelExploreView {
    static func build() -> some View {
        let model = ListModel()
        let intent = ListIntent(model: model)

        let container = MVIContainer(
            intent: intent,
            model: model as ListModelStateProtocol,
            modelChangePublisher: model.objectWillChange)

        return ListView(container: container)
    }
   
