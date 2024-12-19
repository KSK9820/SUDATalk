//
//  RawDataFetchable.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Combine
import Foundation

protocol RawDataFetchable {
    func getDataTaskPublisher(_ request: URLRequest) -> AnyPublisher<Data, Error>
}
