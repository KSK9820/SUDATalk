//
//  AuthInterceptor.swift
//  SUDATalk
//
//  Created by 박다현 on 11/11/24.
//

import Combine
import Foundation

enum TokenRenewalStatus {
    case tokenRenewed
}

final class AuthInterceptor {
    private var cancellables: Set<AnyCancellable> = []
    
    func refreshToken() -> AnyPublisher<TokenRenewalStatus, Error> {
        return Future<TokenRenewalStatus, Error> { promise in
            do {
                let request = try UserRouter.refresh.makeRequest()

                URLSession.shared.dataTaskPublisher(for: request)
                    .map { $0.data }
                    .decode(type: [String: String].self, decoder: JSONDecoder())
                    .sink { completion in
                        if case .failure(let error) = completion {
                            promise(.failure(error))
                        }
                    } receiveValue: { value in
                        if let token = value.values.first {
                            KeyChainManager.shared.save(key: .accessToken, value: token)
                            promise(.success(.tokenRenewed))
                        } else {
                            promise(.failure(NetworkAPIError.unknown))
                        }
                    }
                    .store(in: &self.cancellables)

            } catch {
                print("refreshToken Error:", error)
                promise(.failure(error)) 
            }
        }
        .eraseToAnyPublisher()
    }

}
