//
//  WorkspaceModelStateProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import Foundation

protocol WorkspaceModelStateProtocol: AnyObject {
    var isShowWorkspace: Bool { get }
    var workspaceStatus: WorkSpaceStatus { get }
    var workspaceList: [WorkspacePresentationModel] { get set }
    var isLoaded: Bool { get }
}

enum WorkSpaceStatus {
    case loading
    case none
    case more
}
