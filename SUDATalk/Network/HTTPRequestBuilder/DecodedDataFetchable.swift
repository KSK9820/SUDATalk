//
//  DecodedDataFetchable.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Combine
import Foundation

protocol DecodedDataFetchable {
    func getDecodedDataPublisher<D: Decodable>(response: AnyPublisher<Data, any Error>, model: D.Type) -> AnyPublisher<D, Error>
}
