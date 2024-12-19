//
//  WorkspaceDomainModel.swift
//  SUDATalk
//
//  Created by 김수경 on 12/12/24.
//

import Foundation

struct WorkspaceDomainModel: Codable {
    let workspaceID: String
    var name: String
    var description: String?
    var coverImage: String
    var coverImageData: Data?
    var ownerID: String
    var createdAt: Date
}

extension WorkspaceDomainModel {
    func coverToPresentationModel() -> WorkspacePresentationModel {
        .init(workspaceID: self.workspaceID,
              name: self.name,
              coverImage: self.coverImage,
              coverImageData: self.coverImageData,
              ownerID: self.ownerID,
              createdAt: self.createdAt)
    }
}
