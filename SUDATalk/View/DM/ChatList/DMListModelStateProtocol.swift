//
//  DMListModelStateProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import Foundation

protocol DMListModelStateProtocol: AnyObject {
    var workspace: WorkSpacePresentationModel { get }
    var member: [WorkspaceMemeberPresentation] { get }
    var dmlist: [DMRoomInfoPresentationModel] { get }
}
