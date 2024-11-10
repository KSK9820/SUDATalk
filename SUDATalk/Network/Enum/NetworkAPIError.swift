//
//  NetworkAPIError.swift
//  SUDATalk
//
//  Created by 김수경 on 11/6/24.
//

import Foundation

enum NetworkAPIError: String, Error {
    case E01
    case E02
    case E03
    case E11
    case E13
    case E97
    case E98
    case E99
    case E05
    case unknown
}

extension NetworkAPIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .E01:
            "SLP의 모든 요청 Header에는 SesacKey를 넣어주어야 합니다."
        case .E02:
            "토큰 인증을 실패하였을 경우에 해당합니다."
        case .E03:
            "로그인 실패를 포함하여, 계정 정보 조회에 실패하였을 때 해당하는 응답값입니다."
        case .E05:
            "액세스토큰 만료에 해당하는 응답값입니다."
        case .E11:
            "잘못된 요청입니다."
        case .E13:
            "존재하지 않는 데이터입니다."
        case .E97:
            "정상 라우터가 아닌 경우 해당하는 응답값입니다."
        case .E98:
            "서버에 과호출을 할 때 해당하는 응답값입니다."
        case .E99:
            "내부 서버 오류로 인한 응답값입니다."
        case .unknown:
            "알 수 없는 에러입니다."
        }
    }
}
