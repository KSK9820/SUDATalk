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
    var multipartBody: Data? { get }
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
        
        if let body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }
        
        if let multipartBody {
            urlRequest.httpBody = multipartBody
        }
        
        return urlRequest
    }
}
