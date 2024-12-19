//
//  WorkspacePresentationModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import SwiftUI

struct WorkspacePresentationModel {
    let workspaceID: String
    var name: String
    var description: String?
    var coverImage: String
    var coverImageData: Data?
    var ownerID: String
    var createdAt: Date
    
    var coverImageSwiftUI: Image? {
        if let data = coverImageData,
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        
        return nil
    }
}

extension WorkspacePresentationModel {
    func convertToDomainModel() -> WorkspaceDomainModel {
        .init(workspaceID: self.workspaceID,
              name: self.name,
              coverImage: self.coverImage,
              coverImageData: self.coverImageData,
              ownerID: self.ownerID,
              createdAt: self.createdAt)
    }
}

extension WorkspacePresentationModel: Equatable {}
