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
    @Binding var changedValue: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(container.model.channelList.enumerated()), id: \.element.channelID) { index, item in
                    if item.isMyChannel {
                        NavigationLink {
                            NavigationLazyView(ChannelChattingView.build(item, workspaceID: container.model.workspaceID))
                                .onAppear {
                                    container.intent.action(.resetUnreadChat(idx: index))
                                }
                        } label: {
                            listRow(item)
                                .task {
                                    container.intent.action(.getUnreadChat(idx: index, channelID: item.channelID))
                                    
                                    if let imageUrl = item.coverImageUrl {
                                        container.intent.action(.fetchRoomImage(url: imageUrl, idx: index))
                                    }
                                }
                        }
                    } else {
                        listRow(item)
                            .onTapGesture {
                                container.intent.action(.onTapList)
                            }
                            .alert("GroupChat 참여", isPresented: container.binding(for: \.showAlert)) {
                                NavigationLink {
                                    NavigationLazyView(ChannelChattingView.build(item, workspaceID: container.model.workspaceID))
                                        .onAppear {
                                            container.intent.action(.resetUnreadChat(idx: index))
                                        }
                                } label: {
                                    Text("확인")
                                }
                            }
                            .task {
                                container.intent.action(.getUnreadChat(idx: index, channelID: item.channelID))
                                
                                if let imageUrl = item.coverImageUrl {
                                    container.intent.action(.fetchRoomImage(url: imageUrl, idx: index))
                                }
                            }
                    }
                }
            }
        }
        .onAppear {
            container.intent.action(.viewOnAppear(container.model.workspaceID))    
        }
        .onChange(of: changedValue) { newValue in
            if newValue {
                container.intent.action(.viewOnAppear(container.model.workspaceID))
            }
        }
    }
    
    private func listRow(_ item: ChannelListPresentationModel) -> some View {
        HStack(alignment: .center) {
            if let image = item.coverImage {
                image
                    .roundedImageStyle(width: 50, height: 50)
            } else {
                Images.userDefaultImage
                    .roundedImageStyle(width: 50, height: 50)
            }
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .textStyle(.title2)
                    .foregroundColor(Colors.textPrimary)
                
                Text(item.description ?? "")
                    .textStyle(.caption)
                    .foregroundStyle(Colors.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            if item.unreadsCount != 0 {
                Text("\(item.unreadsCount)")
                    .textStyle(.body)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Colors.primary)
                    )
                    .foregroundColor(Colors.white)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension ExploreView {
    static func build(_ workspaceID: String, changedValue: Binding<Bool>? = nil) -> some View {
        let model = ExploreModel(workspaceID: workspaceID)
        let intent = ExploreIntent(model: model)
        
        let container = Container(
            intent: intent,
            model: model as ExploreModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return ExploreView(container: container, changedValue: changedValue ?? .constant(false))
    }
}
