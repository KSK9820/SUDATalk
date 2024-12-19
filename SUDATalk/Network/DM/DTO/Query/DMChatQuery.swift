//
//  DMChatQuery.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

struct DMChatQuery: Encodable, MultiPartFormDatable {
    let content: String?
    var files: [Data] = []
}
