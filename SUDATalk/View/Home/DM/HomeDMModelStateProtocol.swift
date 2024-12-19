//
//  HomeDMModelStateProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 12/6/24.
//

import Foundation

protocol HomeDMModelStateProtocol: AnyObject {
    var workspace: String { get }
    var dmlist: [DMRoomInfoPresentationModel] { get }
}
