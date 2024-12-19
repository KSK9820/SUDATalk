//
//  DMUserPresentationModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation
import SwiftUI

struct DMUserPresentationModel {
    let userID, email, nickname: String
    var profileImage: String?
    var profileImageData: Data?
    var profileSwiftUIImage: Image? {
        guard let imageData = profileImageData,
              let uiimage = UIImage(data: imageData) else {
            return nil
        }
        
        return Image(uiImage: uiimage)
    }
    
    init() {
        self.userID = ""
        self.email = ""
        self.nickname = ""
        self.profileImage = nil
        self.profileImageData = nil
    }
    
    init(userID: String, email: String, nickname: String, profileImage: String?, profileImageData: Data?) {
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
        self.profileImageData = nil
    }
}

extension DMUserPresentationModel {
    func toEntity() -> UserEntity {
        .init(userID: self.userID,
              email: self.email,
              nickname: self.nickname,
              profileImage: self.profileImage)
    }
}
