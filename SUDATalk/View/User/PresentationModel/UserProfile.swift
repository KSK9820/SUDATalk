//
//  UserProfile.swift
//  SUDATalk
//
//  Created by 김수경 on 11/27/24.
//

import Foundation

struct UserProfile: Codable {
    let userID: String
    let email: String
    var nickname: String?
    var profileImage: String?
    var profileImageData: Data?
}
