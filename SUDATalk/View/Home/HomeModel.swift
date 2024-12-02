//
//  HomeModel.swift
//  SUDATalk
//
//  Created by 박다현 on 12/2/24.
//

import Foundation

final class HomeModel: ObservableObject, HomeModelStateProtocol {
    var workspace: WorkSpacePresentationModel
    
    init(workspace: WorkSpacePresentationModel) {
        self.workspace = workspace
    }
}

extension HomeModel: HomeActionsProtocol {}
