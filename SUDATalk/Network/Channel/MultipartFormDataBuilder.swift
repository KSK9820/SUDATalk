//
//  MultipartFormDataBuilder.swift
//  SUDATalk
//
//  Created by 박다현 on 11/10/24.
//

import Foundation

final class MultipartFormDataBuilder {
    static func createMultipartBody(query: ChatQuery, boundary: String) -> Data {
        var body = Data()
        
        appendField(&body, name: "content", value: query.content, boundary: boundary)
        
        query.files.forEach { data in
            appendImageField(&body, name: "files", imageData: data, boundary: boundary)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    static func createMultipartBody(query: ChannelQuery, boundary: String) -> Data {
        var body = Data()
        
        appendField(&body, name: "name", value: query.name, boundary: boundary)
        appendField(&body, name: "description", value: query.description, boundary: boundary)
        
        if let imageData = query.image {
            appendImageField(&body, name: "image", imageData: imageData, boundary: boundary)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    private static func appendField(_ body: inout Data, name: String, value: String?, boundary: String) {
        guard let value = value else { return }
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }

    private static func appendImageField(_ body: inout Data, name: String, imageData: Data, boundary: String) {
        let filename = "channelImage.jpg"
        let mimeType = "image/jpeg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
    }
}
