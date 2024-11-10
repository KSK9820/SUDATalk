//
//  DMChatQuery.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

struct DMChatQuery: Encodable {
    let content: String?
    var files: [Data] = []
}

extension DMChatQuery {
    func converTo() -> MultipartFormData {
        .init(content: self.content, data: self.files.map { $0.toMultiPartData() })
    }
}
