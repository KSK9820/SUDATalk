//
//  MockURLSessionDataTask.swift
//  WorkspaceNetworkTest
//
//  Created by 김수경 on 1/1/25.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    override func resume() {
        resumeHandler()
    }
}


protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class MockURLSession: URLSessionProtocol {
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

