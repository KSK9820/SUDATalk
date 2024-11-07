//
//  CreateChannelView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import SwiftUI

struct CreateChannelView: View {
    @StateObject private var container: Container<CreateChannelIntent, CreateChannelModelStateProtocol>

    private func bindingName(for keyPath: WritableKeyPath<CreateChannelModelStateProtocol, String>) -> Binding<String> {
        Binding(
            get: { container.model[keyPath: keyPath] },
            set: { newValue in
                container.model.channelName = newValue
            }
        )
    }
    
    private func bindingDesciption(for keyPath: WritableKeyPath<CreateChannelModelStateProtocol, String>) -> Binding<String> {
        Binding(
            get: { container.model[keyPath: keyPath] },
            set: { newValue in
                container.model.description = newValue
            }
        )
    }
    
    var body: some View {
        TextField("채널명을 입력하세요.", text: bindingName(for: \.channelName))
        
        TextField("채널을 설명하세요.", text: bindingName(for: \.description))
        
        Button(action: {
            print("생성하기 버튼 클릭")
        }, label: {
            Text("생성")
        })
    }

}

extension CreateChannelView {
    static func build() -> some View {
        let model = CreateChannelModel()
        let intent = CreateChannelIntent(model: model)
        
        let container = Container(
            intent: intent,
            model: model as CreateChannelModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return CreateChannelView(container: container)
    }
}
