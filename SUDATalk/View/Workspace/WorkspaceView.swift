//
//  WorkspaceView.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import SwiftUI

struct WorkspaceView: View {
    @ObservedObject private var container: Container<WorkspaceIntentHandler, WorkspaceModelStateProtocol>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("워크스페이스 ")
                .font(.title)
                .bold()
                .padding(.top, 60)
                .padding(.bottom, 20)
                .frame(width: ContentSize.workspaceScreen.size.width)
                .background(Colors.lightGray)
            
            switch container.model.workspaceStatus {
            case .loading:
                EmptyView()
            case .none:
                NoneWorkspaceView()
            case .more:
                LazyVStack(alignment: .leading) {
                    ForEach($container.model.workspaceList.indices, id: \.self) { index in
                        Button(action: {
                            setRootView(what: CustomTabView(workspace: container.model.workspaceList[index]))
                        }, label: {
                            WorkspaceListView(workspace: $container.model.workspaceList[index])
                                .task {
    //                                print(container.model.workspaceList[index].coverImageData)
    //                                print($container.model.workspaceList[index].coverImageData.wrappedValue)
                                    if $container.model.workspaceList[index].coverImageData.wrappedValue == nil {
                                        container.intent.handle(intent: .getThumbnailImage(url: container.model.workspaceList[index].coverImage, idx: index))
    //                                    print("asdfasdf", container.model.workspaceList[index].coverImageData)
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
        .task {
            container.intent.handle(intent: .getWorkspace)
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
        @Binding var workspace: WorkspacePresentationModel
        
        var body: some View {
            HStack(spacing: 12) {
                if let workspaceCoverImage = workspace.coverImageData {
                    workspaceCoverImage
                        .roundedImageStyle(width: 40, height: 40)
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
