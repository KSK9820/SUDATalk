//
//  WorkspaceActionsProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import Foundation

protocol WorkspaceActionsProtocol: AnyObject {
    func hideWorkspace()
    func showWorkspace() 
    func getWorkspaceList()
    func fetchThumbnail(_ url: String, idx: Int) 
    func setDisappear()
}
