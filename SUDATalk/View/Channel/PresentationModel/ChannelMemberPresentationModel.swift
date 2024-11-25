//
//  ChannelMemberPresentationModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/25/24.
//

import Foundation

struct ChannelMemberPresentationModel {
    let userID, email, nickname: String
    let profileImage: String?
    var profileImageData: Data?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}
