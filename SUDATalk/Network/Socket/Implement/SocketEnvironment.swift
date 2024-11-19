//
//  SocketEnvironment.swift
//  SUDATalk
//
//  Created by 김수경 on 11/16/24.
//

import Foundation

enum SocketEnvironment {
    case message
}

extension SocketEnvironment: SocketEnvironmentConfigurable {
    var scheme: String {
        switch self {
        case .message:
            return "http"
        }
    }
    
    var baseURL: String {
        get throws {
            switch self {
            case .message:
                guard let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String
                else {
                    throw NetworkError.notFoundBaseURL
                }
                return baseURL
            }
        }
    }
    
    var port: Int? {
        switch self {
        case .message:
            guard let portNum = Bundle.main.infoDictionary?["PortNum"] as? String else {
                return nil
            }
            return Int(portNum)
        }
    }
}
