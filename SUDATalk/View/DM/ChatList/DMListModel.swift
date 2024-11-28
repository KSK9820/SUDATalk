//
//  DMListModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import Combine
import SwiftUI

final class DMListModel: ObservableObject, DMListModelStateProtocol {
    var workspace: WorkSpacePresentationModel = WorkSpacePresentationModel(workspaceID: "", name: "", coverImage: Images.home, ownerID: "", createdAt: Date())
    
    @Published var member: [WorkspaceMemeberPresentation] = [
        WorkspaceMemeberPresentation(userID: "1", email: "", nickname: "dd", profileImage: nil, profileImagefile: nil),
        WorkspaceMemeberPresentation(userID: "2", email: "", nickname: "dd", profileImage: nil, profileImagefile: nil)
    ]
}

extension DMListModel: DMListActionProtocol {
    
}
