//
//  CustomTabView.swift
//  SUDATalk
//
//  Created by 박다현 on 12/2/24.
//

import SwiftUI

struct CustomTabView: View {
    @StateObject var workspaceContainer = WorkspaceView.buildContainer()
    var workspace: WorkspacePresentationModel = SampleTest.workspace
    
    var body: some View {
        TabView {
            Group {
                NavigationStack {
                    NavigationLazyView(
                        HomeView.build(workspace)
                            .contentShape(Rectangle())
                            .dragGesture(direction: .right) {
                                workspaceContainer.intent.handle(intent: .dragRight)
                            }
                    )
                }
                .tabItem {
                    Images.home
                    Text("홈")
                }
                
                NavigationStack {
                    NavigationLazyView(DMListView.build(workspace: workspace))
                }
                .tabItem {
                    Images.message
                    Text("DM")
                }
                
                NavigationStack {
                    NavigationLazyView(title: "채널 탐색", ExploreView.build(workspace.workspaceID))
                }
                .tabItem {
                    Images.profile
                    Text("채널")
                }
                
                NavigationStack {
                }
                .tabItem {
                    Images.setting
                    Text("설정")
                }

            }
        }
        .toolbar(.hidden, for: .tabBar)
        .overlay {
            if workspaceContainer.model.isShowWorkspace {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .opacity(0.3)
                        .ignoresSafeArea()
                    
                    WorkspaceView.build(container: workspaceContainer)
                        .transition(.move(edge: .leading))
                        .dragGesture(direction: .left) {
                            workspaceContainer.intent.handle(intent: .dragLeft)
                        }
                }
            }
        }
        .accentColor(Colors.textPrimary)
    }
}
