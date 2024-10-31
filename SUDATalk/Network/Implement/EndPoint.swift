//
//  EndPoint.swift
//  SUDATalk
//
//  Created by 김수경 on 10/30/24.
//

import Foundation

struct EndPoint: EndPointConfigurable {
    var scheme: String = "https"
    var baseURL: String {
        get throws {
            guard let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String
            else {
                throw NetworkError.notFoundBaseURL
            }
            return baseURL
        }
    }
    var method: HTTPMethod
    var path: [String]
    var header: [String: String]
    var parameter: [URLQueryItem]?
    var body: Encodable?
    var version: String? = "v1"
    var port: Int? = 39093
}

enum EndPointHeader {
    case authorization
    case nonAuthroization
    
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
            case .nonAuthroization:
                return ["Content-Type": "application/json",
                        "SesacKey": apiKey]
            }
        }
    }
}
