//
//  WorkspaceIntentHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import Foundation

final class WorkspaceIntentHandler: IntentProtocol {
    private var model: WorkspaceActionsProtocol
    typealias Intent = WorkspaceIntent
    
    init(model: WorkspaceActionsProtocol) {
        self.model = model
    }
 
    func handle(intent: WorkspaceIntent) {
        switch intent {
        case .dragLeft:
            model.hideWorkspace()
        case .dragRight:
            model.showWorkspace()
        case .getWorkspace:
            model.getWorkspaceList()
        case .getThumbnailImage(let url, let idx):
            model.fetchThumbnail(url, idx: idx)
        case .setDisappear:
            model.setDisappear()
        case .selectWorkspace(let workspace):
            model.setRootWorkspace(workspace)
        }
    }
}

enum WorkspaceIntent: IntentType {
    case dragLeft
    case dragRight
    case getWorkspace
    case getThumbnailImage(url: String, idx: Int)
    case setDisappear
    case selectWorkspace(_ workspace: WorkspacePresentationModel)
}
