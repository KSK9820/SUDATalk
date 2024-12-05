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
        }
    }
}

enum WorkspaceIntent: IntentType {
    case dragLeft
    case dragRight
}
