//
//  EndPointHeader.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Foundation

enum EndPointHeader {
    case authorization
    case nonAuthorization
    case multipartType(boundary: String)
}

extension EndPointHeader {
    var header: [String: String] {
        get throws {
            guard let apiKey = Bundle.main.infoDictionary?["SesacKey"] as? String
            else {
                throw NetworkError.notFoundAPIKey
            }
            
            switch self {
            case .authorization:
                return ["Authroization": "",
                        "Content-Type": "application/json",
                        "SesacKey": apiKey]
            case .nonAuthorization:
                return ["Content-Type": "application/json",
                        "SesacKey": apiKey]
            case .multipartType(let boundary):
                return ["Authorization": "",
                        "Content-Type": "multipart/form-data;boundary=\(boundary)",
                        "SesacKey": apiKey]
            }
        }
    }
}
