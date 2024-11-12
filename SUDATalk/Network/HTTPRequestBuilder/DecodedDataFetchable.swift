//
//  DecodedDataFetchable.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Combine
import Foundation

protocol DecodedDataFetchable {
    func getDecodedDataTaskPublisher<D: Decodable>(_ request: URLRequest, model: D.Type) -> AnyPublisher<D, Error> 
}
