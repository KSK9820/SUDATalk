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
    var coverImageData: Image?
    var ownerID: String
    var createdAt: Date    
}
