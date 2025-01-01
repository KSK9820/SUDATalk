//
//  NetworkManager.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Combine
import Foundation

final class NetworkManager: RawDataFetchable, DecodedDataFetchable {
    private let session: URLSessionProtocol
    private let decoder = DecodedService()
    private let authInterceptor = AuthInterceptor()
    private var cancellables: Set<AnyCancellable> = []
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func getDataTaskPublisher(_ request: URLRequest) -> AnyPublisher<Data, any Error> {
        Future<Data, Error> { [weak self] promise in
            guard let self else { return }
            
            self.session.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    if let data {
                        let error = self.decoder.getErrorDecodingPublisher(response: NetworkError.code(data: data))
                        
                        if error == NetworkAPIError.E02 || error == NetworkAPIError.E05 {
                            self.authInterceptor.refreshToken()
                                .sink { completion in
                                    if case .failure(let error) = completion {
                                        print(error)
                                    }
                                } receiveValue: { value in
                                    if value == .tokenRenewed {
                                        var newRequest = request
                                        newRequest.allHTTPHeaderFields = try? EndPointHeader.refreshToken.header
                                        
                                        self.getDataTaskPublisher(request)
                                            .sink(receiveCompletion: { completion in
                                                if case .failure(let error) = completion {
                                                    promise(.failure(error))
                                                }
                                            }, receiveValue: { data in
                                                promise(.success(data))
                                            })
                                            .store(in: &self.cancellables)
                                    }
                                }
                                .store(in: &self.cancellables)
                        }
                        
                        return promise(.failure(error))
                    } else if let error {
                        
                        return promise(.failure(error))
                    }
                    
                    return promise(.failure(URLError(.unknown)))
                }
                
                if let data {
                    return promise(.success(data))
                }
                
                return promise(.failure(URLError(.unknown)))
            }.resume()
        }
        .eraseToAnyPublisher()
    }
    
    func getDecodedDataTaskPublisher<D: Decodable>(_ request: URLRequest, model: D.Type) -> AnyPublisher<D, Error> {
        decoder.getDecodedDataPublisher(response: getDataTaskPublisher(request), model: model)
    }
    
    func getCachingImageDataTaskPublisher(request: URLRequest, key: String) -> AnyPublisher<Data, any Error> {
        Future<Data, Error> { [weak self] promise in
            guard let self else { return }
            
            if let cachedData = CacheManager.shared.loadFromCache(forKey: key) {
                return promise(.success(cachedData))
            }
            
            if let fileData = ImageFileManager.shared.loadFile(fileUrl: key) {
                CacheManager.shared.saveToCache(data: fileData, forKey: key)
               
                return promise(.success(fileData))
            }
            
            getDataTaskPublisher(request)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { data in
                    CacheManager.shared.saveToCache(data: data, forKey: key)
                    ImageFileManager.shared.saveImageToDocument(image: data, fileUrl: key)
                    
                    return promise(.success(data))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}
