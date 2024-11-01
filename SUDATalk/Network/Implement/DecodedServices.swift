//
//  DecodedServices.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Combine
import Foundation

final class DecodedServices: DecodedDataFetchable {
    private let decoder = JSONDecoder()
    
    func getDecodedDataPublisher<D>(response: AnyPublisher<Data, any Error>, model: D.Type) -> AnyPublisher<D, any Error> where D: Decodable {
        response
            .mapError { error in
                print(error.localizedDescription)
                return error
            }
            .decode(type: model.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
