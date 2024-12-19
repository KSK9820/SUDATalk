//
//  ChannelPresentationModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import Foundation

struct ChannelPresentationModel {
    let channelID: String
    var name: String
    var description, coverImage: String?
    let ownerID, createdAt: String
    var channelMembers: [ChannelMemberPresentationModel]

    init(channelID: String, name: String, description: String?, coverImage: String?, ownerID: String, createdAt: String, channelMembers: [ChannelMemberPresentationModel]) {
        self.channelID = channelID
        self.name = name
        self.description = description
        self.coverImage = coverImage
        self.ownerID = ownerID
        self.createdAt = createdAt
        self.channelMembers = channelMembers
    }
    
    init() {
        self.channelID = ""
        self.name = ""
        self.description = ""
        self.coverImage = ""
        self.ownerID = ""
        self.createdAt = ""
        self.channelMembers = []
    }
}
