//
//  LoginQuery.swift
//  SUDATalk
//
//  Created by 박다현 on 10/31/24.
//

import Foundation

struct LoginQuery: Encodable {
    let email: String
    let password: String
    let deviceToken: String
}
