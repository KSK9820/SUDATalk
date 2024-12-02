//
//  CustomTabView.swift
//  SUDATalk
//
//  Created by 박다현 on 12/2/24.
//

import SwiftUI

struct CustomTabView: View {
    
    var body: some View {
        TabView {
            NavigationStack {
                let workspace = WorkSpacePresentationModel(workspaceID: SampleTest.workspaceID, name: "워크스페이스닷", coverImage: Images.help, ownerID: "", createdAt: Date())
                NavigationLazyView(HomeView.build(workspace))
            }
            .tabItem {
                Images.home
                Text("홈")
            }
            
            NavigationStack {
            }
            .tabItem {
                Images.message
                Text("DM")
            }
            
            NavigationStack {
                NavigationLazyView(title: "채널 탐색", ExploreView.build(SampleTest.workspaceID))
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
        .accentColor(Colors.textPrimary)
    }
}
