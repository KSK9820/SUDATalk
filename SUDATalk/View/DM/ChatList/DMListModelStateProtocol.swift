//
//  DMListModelStateProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import Foundation

protocol DMListModelStateProtocol: AnyObject {
    var workspace: WorkspacePresentationModel { get }
    var member: [WorkspaceMemeberPresentationModel] { get }
    var dmlist: [DMRoomInfoPresentationModel] { get }
    var selectedChat: DMRoomInfoPresentationModel? { get }
}
