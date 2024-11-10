//
//  ModelStateProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

protocol ModelStateProtocol: AnyObject {
    var messageText: String { get set }
    var selectedImages: [Data] { get set }
}
