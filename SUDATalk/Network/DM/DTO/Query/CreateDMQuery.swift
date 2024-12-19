//
//  CreateDMQuery.swift
//  SUDATalk
//
//  Created by 김수경 on 12/17/24.
//

import Foundation

struct CreateDMQuery: Encodable {
    let opponentID: String
    
    enum CodingKeys: String, CodingKey {
        case opponentID = "opponent_id"
    }
}
