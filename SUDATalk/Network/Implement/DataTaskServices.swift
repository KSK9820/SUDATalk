//
//  DataTaskServices.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Combine
import Foundation

final class DataTaskServices: RawDataFetchable {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getDataTaskPublisher(_ request: URLRequest) -> AnyPublisher<Data, any Error> {

        session.dataTaskPublisher(for: request)
            .mapError { error in
                print(error.localizedDescription)
                return error
            }
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
