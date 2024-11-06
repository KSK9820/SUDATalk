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
        Future<Data, Error> { [weak self] promise in
            guard let self else { return }
            
            self.session.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    if let data {
                        return promise(.failure(NetworkError .code(data: data)))
                    } else if let error {
                        return promise(.failure(error))
                    }
                    
                    return promise(.failure(URLError(.unknown)))
                }
                
                if let data {
                    promise(.success(data))
                }
                
                promise(.failure(URLError(.unknown)))
            }.resume()
        }
        .eraseToAnyPublisher()
    }
}
