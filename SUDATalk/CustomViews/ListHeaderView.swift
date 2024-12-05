//
//  ListHeaderView.swift
//  SUDATalk
//
//  Created by 박다현 on 12/2/24.
//

import SwiftUI

struct ListHeaderView: View {
    private var workspace: WorkspacePresentationModel
    
    init(workspace: WorkspacePresentationModel) {
        self.workspace = workspace
    }
    
    var body: some View {
        HStack {
            if let coverImageData = workspace.coverImageData {
                coverImageData
                    .roundedImageStyle(width: 30, height: 30)
                    .padding(.trailing, 8)
            }
            
            Text(workspace.name)
                .textStyle(.title1)
            
            Spacer()
            
            if let userProfileData = UserDefaultsManager.shared.userProfile.profileImageData,
               let userProfileImage = UIImage(data: userProfileData) {
                Image(uiImage: userProfileImage)
                    .circleImageStyle(width: 30, height: 30)
            } else {
                Images.userDefaultImage
                    .circleImageStyle(width: 30, height: 30)
            }
        }
        .padding(.horizontal, 20)
    }
}
