//
//  URLRequestConvertible.swift
//  SUDATalk
//
//  Created by 김수경 on 10/30/24.
//

import Foundation

protocol URLRequestConvertible {
    func asURL() throws -> URL
    func asURLRequest() throws -> URLRequest
}
