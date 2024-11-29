//
//  WorkspaceMemeberPresentation.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import SwiftUI

struct WorkspaceMemeberPresentation {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    let profileImagefile: Data?
    
    init(userID: String, email: String, nickname: String, profileImage: String?, profileImagefile: Data? = nil) {
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
        self.profileImagefile = profileImagefile
    }
}
