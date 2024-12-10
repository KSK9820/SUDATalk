//
//  HomeView.swift
//  SUDATalk
//
//  Created by 박다현 on 12/2/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var container: Container<HomeIntent, HomeModelStateProtocol>
    
    @State private var isChannelExpanded = false
    @State private var isDMlExpanded = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ListHeaderView(workspace: container.model.workspace)
                
                Divider()
                
                SectionWrap(title: "채널", content: ChannelSection(workSpaceID: container.model.workspace.workspaceID), isExpanded: $isChannelExpanded)
                
                Divider()
                
                SectionWrap(title: "DM", content: DMSection(workSpaceID: container.model.workspace.workspaceID), isExpanded: $isDMlExpanded)
                    .onChange(of: $isDMlExpanded.wrappedValue) { newValue in
                           if newValue {
                               Task {
                                   container.intent.action(.getDMList)
                               }
                           }
                       }
                
                Divider()
                
                Spacer()
            }
        }
    }
}

struct SectionWrap<Content: View>: View {
    var title: String
    var content: Content
    var isExpanded: Binding<Bool>
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.wrappedValue.toggle()
                }
            }, label: {
                HStack {
                    Text(title)
                        .textStyle(.title2)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    (isExpanded.wrappedValue ? Images.chevronDown : Images.chevronUp)
                }
            })
            
            if isExpanded.wrappedValue {
                content
            }
        }
        .padding()
    }
}

struct ChannelSection: View {
    var workSpaceID: String
    
    @State private var showActionSheet = false
    @State private var showSheet = false
    @State private var moveNextView = false
    @State private var changedValue = false
    
    var body: some View {
        ExploreView.build(workSpaceID, changedValue: $changedValue)
            .padding(.horizontal, -16)
        
        Button {
            showActionSheet = true
        } label: {
            HStack {
                Images.plus
                
                Text("채널추가")
                    .textStyle(.title2)
                    .foregroundStyle(Colors.textSecondary)
                
                Spacer()
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("옵션을 선택하세요"),
                buttons: [
                    .default(Text("채널 추가")) {
                        showSheet = true
                    },
                    .default(Text("채널 탐색")) {
                        moveNextView = true
                    },
                    .cancel()
                ]
            )
        }
        .navigationDestination(isPresented: $moveNextView) {
            NavigationLazyView(title: "채널 탐색", ExploreView.build(workSpaceID))
        }
        .sheet(isPresented: $showSheet) {
            NavigationLazyView(CreateChannelView.build() { _ in
                changedValue = true
            })
        }
    }
}

struct DMSection: View {
    var workSpaceID: String
    
    @State private var showActionSheet = false
    @State private var showSheet = false
    @State private var moveNextView = false
    @State private var changedValue = false
    
    var body: some View {
        VStack(spacing: 12) {
            HomeDMView.build(workspace: workSpaceID)
                
            Button {
                showActionSheet = true
            } label: {
                HStack {
                    Images.plus
                    
                    Text("새 매시지 시작")
                        .textStyle(.title2)
                        .foregroundStyle(Colors.textSecondary)
                    
                    Spacer()
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("옵션을 선택하세요"),
                    buttons: [
                        .default(Text("채널 추가")) {
                            showSheet = true
                        },
                        .default(Text("채널 탐색")) {
                            moveNextView = true
                        },
                        .cancel()
                    ]
                )
            }
            .navigationDestination(isPresented: $moveNextView) {
                NavigationLazyView(title: "채널 탐색", ExploreView.build(workSpaceID))
            }
            .sheet(isPresented: $showSheet) {
                NavigationLazyView(CreateChannelView.build() { _ in
                    changedValue = true
                })
            }
        }
    }
}

extension HomeView {
    static func build(_ workSpace: WorkspacePresentationModel) -> some View {
        let model = HomeModel(workspace: workSpace)
        let intent = HomeIntent(model: model)
        
        let container = Container(
            intent: intent,
            model: model as HomeModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return HomeView(container: container)
    }
}
