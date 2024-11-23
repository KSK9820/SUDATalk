//
//  UserEntity.swift
//  SUDATalk
//
//  Created by 김수경 on 11/23/24.
//

import Foundation
import RealmSwift

final class UserEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var userID: String
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(userID: String, email: String, nickname: String, profileImage: String? = nil) {
        self.init()
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
    
    func convertToModel() -> ChatUserPresentationModel {
        .init(userID: userID, email: email, nickname: nickname, profileImageUrl: profileImage, profileImageData: Data())
    }
    
    func convertToModel() -> DMUserPresentationModel {
        .init(userID: self.userID,
              email: self.email,
              nickname: self.nickname,
              profileImage: self.profileImage,
              profileImageData: nil)
    }
}
