//
//  MultiPartFormDataQuery.swift
//  SUDATalk
//
//  Created by 김수경 on 11/13/24.
//

import Foundation

protocol MultiPartFormDatable {
    var content: String? { get }
    var files: [Data] { get }
}
