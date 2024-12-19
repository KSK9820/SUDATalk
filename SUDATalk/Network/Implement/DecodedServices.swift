//
//  DecodedServices.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Combine
import Foundation

final class DecodedService {
    private let decoder = JSONDecoder()
    private let authInterceptor = AuthInterceptor()
    private var cancellables: Set<AnyCancellable> = []
    
    func getErrorDecodingPublisher(response: Error) -> NetworkAPIError {
        guard let networkError = response as? NetworkError else {
            return NetworkAPIError.unknown
        }
        
        if case .code(let data) = networkError {
            guard let errorCode = try? self.decoder.decode([String: String].self, from: data),
                  let errorValue = errorCode.values.first,
                  let errorType = NetworkAPIError(rawValue: errorValue)
            else {
                return NetworkAPIError.unknown
            }
            
            return errorType
        }
        return NetworkAPIError.unknown
    }
    
    func getDecodedDataPublisher<D>(response: AnyPublisher<Data, any Error>, model: D.Type) -> AnyPublisher<D, any Error> where D: Decodable {
        response
            .decode(type: model.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
