//
//  EndPoint.swift
//  SUDATalk
//
//  Created by 김수경 on 10/30/24.
//

import Foundation

struct EndPoint: EndPointConfigurable {
    var scheme: String = "http"
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
    var multipartBody: Data?
    var version: String? = "v1"
    var port: Int? {
        guard let portNum = Bundle.main.infoDictionary?["PortNum"] as? String else {
            return nil
        }
        return Int(portNum)
    }
}
