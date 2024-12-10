//
//  LoginModelStateProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 12/5/24.
//

import Foundation

protocol LoginModelStateProtocol {
    var userID: String { get set }
    var userPW: String { get set }
    var loginSuccessful: Bool { get }
}
