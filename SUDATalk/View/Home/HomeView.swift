//
//  HomeView.swift
//  SUDATalk
//
//  Created by 박다현 on 12/2/24.
//

import Foundation

import SwiftUI

struct HomeView: View {
    @StateObject private var container: Container<HomeIntent, HomeModelStateProtocol>
    
    @State private var isChannelExpanded = true
    @State private var isDMlExpanded = true
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ListHeaderView(workspace: container.model.workspace)
                
                Divider()
                
                SectionWrap(title: "채널", content: ChannelSection(workSpaceID: container.model.workspace.workspaceID), isExpanded: $isChannelExpanded)
                
                Divider()
                
                SectionWrap(title: "DM", content: DMSection(), isExpanded: $isDMlExpanded)
                
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
                .padding(.bottom)
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
    
    var body: some View {
        ExploreView.build(workSpaceID)
            .padding(.horizontal, -16)
        
        Button {
            showActionSheet = true
        } label: {
            HStack() {
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
            NavigationLazyView(CreateChannelView.build())
        }
    }
}

struct DMSection: View {
    var body: some View {
        Text("여기는 DM list자리")
    }
}


extension HomeView {
    static func build(_ workSpace: WorkSpacePresentationModel) -> some View {
        let model = HomeModel(workspace: workSpace)
        let intent = HomeIntent(model: model)
        
        let container = Container(
            intent: intent,
            model: model as HomeModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return HomeView(container: container)
    }
}
