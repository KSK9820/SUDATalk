//
//  WorkspaceView.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import SwiftUI

struct WorkspaceView: View {
    @ObservedObject var container: Container<WorkspaceIntentHandler, WorkspaceModelStateProtocol>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("워크스페이스")
                .font(.title)
                .bold()
                .padding(.top, 60)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .background(Colors.lightGray)
            
            switch container.model.workspaceStatus {
            case .loading:
                EmptyView()
            case .none:
                NoneWorkspaceView()
            case .more:
                LazyVStack(alignment: .leading) {
                    ForEach(Array(container.model.workspaceList.enumerated()), id: \.offset) { index, value in
                        Button(action: {
                            setRootView(what: CustomTabView(workspace: value))
                            container.intent.handle(intent: .selectWorkspace(value))
                        }, label: {
                            WorkspaceListView(workspace: value, idx: index)
                                .onAppear {
                                    if container.model.isLoaded && container.model.workspaceList[index].coverImageData == nil {
                                        container.intent.handle(intent: .getThumbnailImage(url: value.coverImage, idx: index))
                                    }
                                }
                        })
                    }
                }
            }
            
            Spacer()
            
            SystemImageButton(systemImage: Images.plus, text: "워크스페이스 추가") {
                
            }
            .padding(.horizontal, 20)
            
            SystemImageButton(systemImage: Images.help, text: "도움말") {
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
        }
        .frame(width: ContentSize.workspaceScreen.size.width)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: ContentSize.workspaceScreen.cornerRadius))
        .ignoresSafeArea()
        .onAppear {
            container.intent.handle(intent: .getWorkspace)
        }
        .onDisappear {
            container.intent.handle(intent: .setDisappear)
        }
    }
    
    private struct NoneWorkspaceView: View {
        var body: some View {
            VStack(alignment: .center) {
                Text("워크스페이스를\n찾을 수 없어요.")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("관리자에게 초대를 요청하거나,\n다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요.")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                
                Text("워크스페이스 생성")
                    .wrapToDefaultButton(active: .constant(true)) {
                        
                    }
                    .padding()
            }
        }
    }
    
    private struct WorkspaceListView: View {
        var workspace: WorkspacePresentationModel
        var idx: Int
        
        var body: some View {
            HStack(spacing: 12) {
                if let workspaceCoverImage = workspace.coverImageSwiftUI {
                    workspaceCoverImage
                        .roundedImageStyle(width: 40, height: 40)
                } else {
                    EmptyView()
                        .frame(width: 40, height: 40)
                }
                
                VStack(alignment: .leading) {
                    Text(workspace.name)
                        .bold()
                    Text(workspace.createdAt.toString(style: .yymmddDot) ?? "")
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}

extension WorkspaceView {
    static func buildContainer() -> Container<WorkspaceIntentHandler, WorkspaceModelStateProtocol> {
        let model = WorkspaceModel()
        let intent = WorkspaceIntentHandler(model: model)
        
        return Container(
            intent: intent,
            model: model as WorkspaceModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
    }
    
    static func build(container: Container<WorkspaceIntentHandler, WorkspaceModelStateProtocol>) -> some View {
        return WorkspaceView(container: container)
    }
}
