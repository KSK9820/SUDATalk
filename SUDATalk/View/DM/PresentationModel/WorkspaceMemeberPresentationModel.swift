//
//  WorkspaceMemeberPresentationModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import SwiftUI

struct WorkspaceMemeberPresentationModel {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    var profileImagefile: Data?
    
    var profileSwiftUIImage: Image {
        if let image = profileImagefile,
           let uiimage = UIImage(data: image) {
            return Image(uiImage: uiimage)
        }
        return Images.userDefaultImage
    }
    
    init(userID: String, email: String, nickname: String, profileImage: String?, profileImagefile: Data? = nil) {
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
        self.profileImagefile = profileImagefile
    }
}
