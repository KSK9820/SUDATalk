//
//  WorkspaceModel.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import Foundation

final class WorkspaceModel: ObservableObject, WorkspaceModelStateProtocol {
    @Published var isShowWorkspace: Bool = false
}

extension WorkspaceModel: WorkspaceActionsProtocol {
    func hideWorkspace() {
        isShowWorkspace = false
    }
    
    func showWorkspace() {
        isShowWorkspace = true
    }
}
