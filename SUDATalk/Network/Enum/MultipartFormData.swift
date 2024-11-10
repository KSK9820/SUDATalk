//
//  MultipartFormData.swift
//  SUDATalk
//
//  Created by 김수경 on 11/6/24.
//

import Foundation

struct MultipartFormData {
    let content: String?
    let data: [MultipartBodyData]?
}

struct MultipartBodyData {
    let name: String
    let fileName: String
    let mimeType: String
    let data: Data
}
