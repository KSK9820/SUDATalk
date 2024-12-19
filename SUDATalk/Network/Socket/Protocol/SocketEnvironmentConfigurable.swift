//
//  SocketEnvironmentConfigurable.swift
//  SUDATalk
//
//  Created by 김수경 on 11/16/24.
//

import Foundation

protocol SocketEnvironmentConfigurable {
    var scheme: String { get }
    var baseURL: String { get throws }
    var port: Int? { get }
}

extension SocketEnvironmentConfigurable {
    func asURL() throws -> URL {
        var components = URLComponents()
        
        components.scheme = scheme
        components.host = try baseURL
        
        if let port {
            components.port = port
        }
        
        guard let url = components.url else {
            throw NetworkError.unknown
        }
        
        return url
    }
}
