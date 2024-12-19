//
//  CustomTabView.swift
//  SUDATalk
//
//  Created by 박다현 on 12/2/24.
//

import SwiftUI

struct CustomTabView: View {
    @StateObject var workspaceContainer = WorkspaceView.buildContainer()
    var workspace: WorkspacePresentationModel = UserDefaultsManager.shared.workspace.coverToPresentationModel()
    
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
                    Text("Home")
                }
                
                NavigationStack {
                    NavigationLazyView(DMListView.build(workspace: workspace))
                }
                .tabItem {
                    Images.dm
                    Text("DM")
                }
                
                NavigationStack {
                    NavigationLazyView(title: "GroupChat 탐색", ExploreView.build(workspace.workspaceID))
                }
                .tabItem {
                    Images.profile
                    Text("GroupChat")
                }
                
                NavigationStack {
                }
                .tabItem {
                    Images.setting
                    Text("Setting")
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
        .accentColor(Colors.primary)
    }
}
