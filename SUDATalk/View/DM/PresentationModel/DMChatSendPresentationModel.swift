//
//  DMChatSendPresentationModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/21/24.
//

import UIKit

struct DMChatSendPresentationModel {
    var content: String = ""
    var files: [UIImage] = []
}

extension DMChatSendPresentationModel {
    func toDTOModel() -> DMChatQuery {
        .init(content: self.content, files: ImageConverter.shared.convertToData(images: self.files))
    }
}
