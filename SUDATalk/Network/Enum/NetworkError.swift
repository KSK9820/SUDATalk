//
//  NetworkError.swift
//  SUDATalk
//
//  Created by 김수경 on 10/30/24.
//

import Foundation

enum NetworkError: Error {
    case unknown
    case notFoundBaseURL
    case notFoundAPIKey
    case code(data: Data)
}

extension NetworkError: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown:
            return "알 수 없는 에러입니다."
        case .notFoundBaseURL:
            return "BaseURL이 없습니다."
        case .notFoundAPIKey:
            return "APIKey가 없습니다."
        default:
            return ""
        }
    }
}
