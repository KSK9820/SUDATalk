//
//  WorkspaceView.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import SwiftUI

struct WorkspaceView: View {
    @StateObject private var container: Container<WorkspaceIntentHandler, WorkspaceModelStateProtocol>
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
          
        }
        .frame(width: ContentSize.workspaceScreen.size.width)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: ContentSize.workspaceScreen.cornerRadius))
        .ignoresSafeArea()
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

//#Preview {
//    WorkspaceView.build()
//}
