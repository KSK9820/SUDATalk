//
//  CreateChannelView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import SwiftUI

struct CreateChannelView: View {
    @StateObject private var container: Container<CreateChannelIntent, CreateChannelModelStateProtocol>
    @Environment(\.dismiss) var dismiss

    var isModifiedData: ((ChannelListPresentationModel) -> Void)?

    var body: some View {
        VStack {
            textfieldRow("GroupChat 이름", description: "GroupChat명을 입력하세요.", value: container.binding(for: \.channelName))
            textfieldRow("GroupChat 설명", description: "GroupChat을 설명하세요.", value: container.binding(for: \.description))
            
            Spacer()
            
            Text(container.model.isEditMode ? "편집하기" : "생성하기")
                .wrapToDefaultButton(active: container.binding(for: \.activeSubmit)) {
                    let input = ChannelInputModel(name: container.binding(for: \.channelName).wrappedValue, description: container.binding(for: \.description).wrappedValue, image: nil)
                    if container.model.isEditMode {
                        container.intent.action(.editChannel(UserDefaultsManager.shared.workspace.workspaceID, input: input))
                    } else {
                        container.intent.action(.createChannel(UserDefaultsManager.shared.workspace.workspaceID, input: input))
                    }
                }
        }
        .padding()
        .navigationTitle("GroupChat 생성")
        .onChange(of: container.model.modifiedChannel) { newValue in
            if let newValue {
                isModifiedData?(newValue)
                dismiss()
            }
        }
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
        let value = !container.binding(for: \.channelName).wrappedValue.isEmpty && !container.binding(for: \.description).wrappedValue.isEmpty
        container.binding(for: \.activeSubmit).wrappedValue = value
    }
}

extension CreateChannelView {
    static func build(_ channelID: String? = nil, name: String? = nil, description: String? = nil, modified: ((ChannelListPresentationModel) -> Void)? = nil) -> some View {
        let model = CreateChannelModel()
        let intent = CreateChannelIntent(model: model)
        
        if let name {
            model.channelName = name
            model.channelID = channelID
            model.isEditMode = true
        }
        
        if let description {
            model.description = description
        }
        
        let container = Container(
            intent: intent,
            model: model as CreateChannelModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return CreateChannelView(container: container, isModifiedData: modified)
    }
}
