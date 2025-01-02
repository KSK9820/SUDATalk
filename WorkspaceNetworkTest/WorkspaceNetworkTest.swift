//
//  WorkspaceNetworkTest.swift
//  WorkspaceNetworkTest
//
//  Created by 김수경 on 1/1/25.
//

import XCTest
import Combine
@testable import SUDATalk

final class WorkspaceNetworkTest: XCTestCase {
    var sut: NetworkManager!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_Workspace의_응답값이_있을_경우() {
        let request = WorkspaceRouter.workspaceList
        
        // given
        let mockResponse: MockURLSession.Response = {
            let url = try! request.makeURL()
            let data = JSONLoader.loadData(filename: "MockWorkspaceResponse")
            let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            
            return (data: data,
                        urlResponse: successResponse,
                        error: nil)
        }()
        let mockURLSession = MockURLSession(response: mockResponse)
        
        sut = NetworkManager(session: mockURLSession)
        
        //when
        var result: [WorkspaceResponse]?
        
        sut.getDecodedDataTaskPublisher(try! request.makeRequest(), model:  [WorkspaceResponse].self)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { value in
                result = value
            }
            .store(in: &cancellables)
        
        // then
        let expectation = JSONLoader.loadDecodedData(fileName: "MockWorkspaceResponse", type: [WorkspaceResponse].self)
        
        XCTAssertEqual(result, expectation)
    }

    func test_Workspace의_디코딩을_실패할_경우() {
        let request = WorkspaceRouter.workspaceList
        
        // given
        let mockResponse: MockURLSession.Response = {
            let url = try! request.makeURL()
            let data = JSONLoader.loadData(filename: "MockWorkspaceFailureResponse")
            let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse)
        sut = NetworkManager(session: mockURLSession)
        
        // when
        var result: [WorkspaceResponse]?
        var receivedError: Error?
        
        sut.getDecodedDataTaskPublisher(try! request.makeRequest(), model: [WorkspaceResponse].self)
            .sink { completion in
                
                if case .failure(let error) = completion {
                    print(error)
                    receivedError = error
                    
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            XCTAssertEqual(key.stringValue, "workspace_id")
                            XCTAssertNotNil(context.codingPath)
                        default:
                            XCTFail("Unexpected decoding error")
                        }
                    } else {
                        XCTFail("Expected DecodingError, but got \(error)")
                    }
                }
            } receiveValue: { value in
                result = value
            }
            .store(in: &cancellables)
        
        // then
        XCTAssertNil(result)
        XCTAssertNotNil(receivedError)
        XCTAssertTrue(receivedError is DecodingError, "Error should be of type DecodingError")
    }
}
