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
    
    private func bindingSubmitButton(for keyPath: WritableKeyPath<CreateChannelModelStateProtocol, Bool>) -> Binding<Bool> {
        Binding(
            get: { container.model[keyPath: keyPath] },
            set: { newValue in
                container.model.activeSubmit = newValue
            }
        )
    }
    
    var body: some View {
        VStack {
            textfieldRow("채널 이름", description: "채널명을 입력하세요.", value: bindingName(for: \.channelName))
            textfieldRow("채널 설명", description: "채널을 설명하세요.", value: bindingDesciption(for: \.description))
            
            Spacer()
            
            Text("생성")
                .wrapToDefaultButton(active: bindingSubmitButton(for: \.activeSubmit)) {
                    let input = ChannelInput(name: bindingName(for: \.channelName).wrappedValue, description: bindingName(for: \.description).wrappedValue, image: nil)
                    container.intent.createChannel(SampleTest.workspaceID, input: input)
                }

        }
        .padding()
        .navigationTitle("채널 생성")

    }
    
    private func textfieldRow(_ title: String, description: String, value: Binding<String>) -> some View {
        VStack {
            Text(title)
                .textStyle(.bodyBold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField(description, text: value)
                .textStyle(.body)
                .padding(5)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
                .onChange(of: value.wrappedValue) { _ in
                    updateSubmitButtonState()
                }
        }
    }
    
    private func updateSubmitButtonState() {
        let value = !bindingName(for: \.channelName).wrappedValue.isEmpty && !bindingName(for: \.description).wrappedValue.isEmpty
        bindingSubmitButton(for: \.activeSubmit).wrappedValue = value
    }
}

extension CreateChannelView {
    static func build(_ name: String? = nil, description: String? = nil) -> some View {
        let model = CreateChannelModel()
        let intent = CreateChannelIntent(model: model)
        
        if let name, let description {
            model.channelName = name
            model.description = description
        }
        
        let container = Container(
            intent: intent,
            model: model as CreateChannelModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return CreateChannelView(container: container)
    }
}
