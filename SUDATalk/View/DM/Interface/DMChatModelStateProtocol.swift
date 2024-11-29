//
//  DMChatModelStateProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import UIKit
import SwiftUI

protocol DMChatModelStateProtocol: AnyObject {
    var dmRoomInfo: DMRoomInfoPresentationModel { get }
    var chatting: [DMChatPresentationModel] { get }
    var opponentProfileImage: Image { get }
    var myProfileImage: Image { get }
    var dmInput: DMChatSendPresentationModel { get set }
}
