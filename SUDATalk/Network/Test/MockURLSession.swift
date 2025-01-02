//
//  MockURLSession.swift
//  SUDATalk
//
//  Created by 박다현 on 1/2/25.
//

import Foundation

final class MockURLSession: URLSessionProtocol {
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: (any Error)?)
    
    let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
        MockURLSessionDataTask {
            completionHandler(self.response.data, self.response.urlResponse, self.response.error)
        }
    }
}
