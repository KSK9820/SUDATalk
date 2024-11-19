//
//  DMUserPresentationModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

struct DMUserPresentationModel {
    let userID, email, nickname: String
    let profileImage: String?
    
    init() {
        self.userID = ""
        self.email = ""
        self.nickname = ""
        self.profileImage = nil
    }
    
    init(userID: String, email: String, nickname: String, profileImage: String?) {
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
