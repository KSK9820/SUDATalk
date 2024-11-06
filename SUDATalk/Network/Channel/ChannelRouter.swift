//
//  ChannelRouter.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import UIKit

enum ChannelRouter {
    case channel(param: String)
    case myChannel(param: String)
    case sendChat(workspaceID: String, channelID: String, query: ChatQuery)
    case fetchChat(workspaceID: String, channelID: String, date: String)
    case fetchImage(url: String)
}

extension ChannelRouter {
    func makeRequest() throws -> URLRequest {
        switch self {
        case .channel(let param):
            return try EndPoint(
                method: .get,
                path: ["workspaces", param, "channels"],
                header: EndPointHeader.authorization.header
            ).asURLRequest()
        case .myChannel(let param):
            return try EndPoint(
                method: .get,
                path: ["workspaces", param, "my-channels"],
                header: EndPointHeader.authorization.header
            ).asURLRequest()
        case .sendChat(let workspaceID, let channelID, let query):
            let boundary = "Boundary-\(UUID().uuidString)"
            let body = createMultipartBody(content: query.content, images: query.files, boundary: boundary, maxSizeMB: 10)

            return try EndPoint(
                method: .post,
                path: ["workspaces", workspaceID, "channels", channelID, "chats"],
                header: EndPointHeader.multipartType(boundary: boundary).header,
                multipartBody: body
            ).asURLRequest()
        case .fetchChat(let workspaceID, let channelID, let date):
            return try EndPoint(
                method: .get,
                path: ["workspaces", workspaceID, "channels", channelID, "chats"],
                header: EndPointHeader.authorization.header,
                parameter: [URLQueryItem(name: "cursor_date", value: date)]
            ).asURLRequest()
        case .fetchImage(url: let url):
            let arrUrl = url.split(separator: "/").map{ String($0) }
            
            return try EndPoint(
                method: .get,
                path: arrUrl,
                header: EndPointHeader.multipartType(boundary: "Boundary-\(UUID().uuidString)").header
            ).asURLRequest()
        }
    }
    
    private func createMultipartBody(content: String, images: [UIImage], boundary: String, maxSizeMB: Double) -> Data {
        var body = Data()
        
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"content\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(content)\r\n".data(using: .utf8)!)

        for (index, image) in images.enumerated() {
            var compressionQuality: CGFloat = 0.8
            var imageData = image.jpegData(compressionQuality: compressionQuality)
            
            while let data = imageData, Double(data.count) / (1024 * 1024) > maxSizeMB, compressionQuality > 0.1 {
                compressionQuality -= 0.1
                imageData = image.jpegData(compressionQuality: compressionQuality)
            }

            if let data = imageData, Double(data.count) / (1024 * 1024) > maxSizeMB {
                print("이미지[\(index)]가 용량을 초과합니다.")
                continue
            }

            if let data = imageData {
                let filename = "chatimage\(index).jpg"
                let mimeType = "image/jpeg"
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
