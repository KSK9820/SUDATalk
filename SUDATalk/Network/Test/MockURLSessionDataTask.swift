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

