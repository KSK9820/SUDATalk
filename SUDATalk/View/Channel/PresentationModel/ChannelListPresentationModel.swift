//
//  ChannelListPresentationModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import SwiftUI

struct ChannelListPresentationModel {
    let channelID, name: String
    let description, coverImageUrl: String?
    let ownerID: String
    let createdAt: Date
    var isMyChannel: Bool = false
    var unreadsCount: Int = 0
    var coverImage: Image?

    func convertToEntity() -> ChannelEntity {
        .init(channelID: channelID, name: name, details: description, coverImage: coverImageUrl, ownerID: ownerID, createdAt: createdAt)
    }
}

extension ChannelListPresentationModel: Equatable {}
