//
//  WorkspaceResponse.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import Foundation

struct WorkspaceResponse: Decodable {
    let workspaceID: String
    let name: String
    var description: String?
    let coverImage: String
    let ownerID: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name
        case description
        case coverImage
        case ownerID = "owner_id"
        case createdAt
    }
}

extension WorkspaceResponse {
    func converToModel() -> WorkspacePresentationModel {
        .init(workspaceID: self.workspaceID,
              name: self.name,
              coverImage: self.coverImage,
              ownerID: self.ownerID,
              createdAt: self.createdAt.convertToDate())
    }
}
