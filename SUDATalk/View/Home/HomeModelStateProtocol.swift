//
//  HomeModelStateProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 12/2/24.
//

import Foundation

protocol HomeModelStateProtocol: AnyObject {
    var workspace: WorkspacePresentationModel { get }
    var dmlist: [DMRoomInfoPresentationModel] { get }
}
