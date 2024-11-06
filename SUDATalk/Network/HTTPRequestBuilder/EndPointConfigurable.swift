//
//  EndPointConfigurable.swift
//  SUDATalk
//
//  Created by 김수경 on 10/30/24.
//

import Foundation

protocol EndPointConfigurable: URLRequestConvertible {
    var scheme: String { get }
    var baseURL: String { get throws }
    var method: HTTPMethod { get }
    var path: [String] { get }
    var header: [String: String] { get throws }
    var parameter: [URLQueryItem]? { get }
    var body: Encodable? { get }
    var multipartFormData: MultipartFormData? { get }
    var version: String? { get }
    var port: Int? { get }
}

extension EndPointConfigurable {
    func asURL() throws -> URL {
        var components = URLComponents()
        
        components.scheme = scheme
        components.host = try baseURL
        
        if let version {
            components.path = "/\(version)/" + path.joined(separator: "/")
        } else {
            components.path = "/" + path.joined(separator: "/")
        }
        
        if let parameter {
            components.queryItems = parameter
        }
        
        if let port {
            components.port = port
        }
        
        guard let url = components.url else {
            throw NetworkError.unknown
        }

        return url
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try asURL()
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = try header
            
        if let multipartFormData {
            let boundary = UUID().uuidString
            
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = createMultipartBody(boundary: boundary, formDatas: multipartFormData)
        } else if let body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }
        
        return urlRequest
    }
    
    private func createMultipartBody(boundary: String, formDatas: MultipartFormData) -> Data {
        var body = Data()
       
        if let content = formDatas.content {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"content\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(content)\r\n".data(using: .utf8)!)
        }
        
        if let datas = formDatas.data {
            for data in datas {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(data.name)\"; filename=\"\(data.fileName)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(data.mimeType)\r\n\r\n".data(using: .utf8)!)
                body.append(data.data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}
