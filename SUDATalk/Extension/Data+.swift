//
//  Data++Extension.swift
//  SUDATalk
//
//  Created by 김수경 on 11/6/24.
//

import Foundation
import UniformTypeIdentifiers

extension Data {
    func createFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = dateFormatter.string(from: Date())
        
        return "file_\(dateString)"
    }
    
    func getMimeType(for data: Data) -> String {
        let bytes = [UInt8](data.prefix(1))
        
        switch bytes {
        case [0xFF]: return "image/jpeg"
        case [0x89]: return "image/png"
        case [0x47]: return "image/gif"
        case [0x49], [0x4D]: return "image/tiff"
        default: return "application/octet-stream"
        }
    }
}
