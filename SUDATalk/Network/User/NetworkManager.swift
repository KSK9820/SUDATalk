//
//  NetworkManager.swift
//  SUDATalk
//
//  Created by 김수경 on 10/31/24.
//

import Foundation
import Combine

final class NetworkManager {
    private let dataTaskServices: RawDataFetchable
    private let decodedServices: DecodedDataFetchable
    
    init(dataTaskServices: RawDataFetchable, decodedServices: DecodedDataFetchable) {
        self.dataTaskServices = dataTaskServices
        self.decodedServices = decodedServices
    }
    
    func fetchData(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        dataTaskServices.getDataTaskPublisher(request)
    }
    
    func fetchDecodedData<D: Decodable>(_ request: URLRequest, model: D.Type) -> AnyPublisher<D, Error> {
        let data = fetchData(request)
        
        return decodedServices.getDecodedDataPublisher(response: data, model: model)
    }
}
