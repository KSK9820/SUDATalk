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
    var coverImageData: UIImage?
    var ownerID: String
    var createdAt: Date
    
    var coverImageSwiftUI: Image? {
        guard let image = coverImageData else {
            return nil
        }
            return Image(uiImage: image)
        }
}

extension WorkspacePresentationModel: Equatable {}
