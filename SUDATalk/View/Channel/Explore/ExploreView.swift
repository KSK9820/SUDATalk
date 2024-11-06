//
//  ExploreView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var container: Container<ExploreIntent, ExploreModelStateProtocol>
    @State private var showAlert = false
    
    private func binding(for keyPath: WritableKeyPath<ExploreModelStateProtocol, Bool>) -> Binding<Bool> {
        Binding(
            get: { container.model[keyPath: keyPath] },
            set: { newValue in
                container.model.showAlert = newValue
            }
        )
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(container.model.channelList, id: \.channelID) { item in
                    if item.isMyChannel {
                        NavigationLink {
                            NavigationLazyView(ChannelChattingView.build(item, workspaceID: container.model.workspaceID))
                        } label: {
                            listRow(item)
                        }
                    } else {
                        listRow(item)
                            .onTapGesture {
                                container.intent.onTapList()
                            }
                            .alert("채널 참여", isPresented: binding(for: \.showAlert)) {
                                Button("확인", role: .cancel) { }
                            }
                    }
                }
            }
        }
        .navigationTitle("채널탐색")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            container.intent.viewOnAppear(container.model.workspaceID)
        }
    }
    
    private func listRow(_ item: ChannelListPresentationModel) -> some View {
        HStack(alignment: .top) {
            Images.tag
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .textStyle(.title2)
                    .foregroundColor(Colors.textPrimary)
                
                Text(item.description ?? "")
                    .textStyle(.caption)
                    .foregroundStyle(Colors.textSecondary)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension ExploreView {
    static func build() -> some View {
        let model = ExploreModel()
        let intent = ExploreIntent(model: model)
        
        let container = Container(
            intent: intent,
            model: model as ExploreModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return ExploreView(container: container)
    }
}
