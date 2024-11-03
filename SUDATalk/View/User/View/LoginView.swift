//
//  LoginView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Combine
import SwiftUI

struct LoginView: View {
    private let networkManager = NetworkManager(dataTaskServices: DataTaskServices(), decodedServices: DecodedServices())
    
    @State var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .padding()
        .task {
            let query = SampleTest.user1
            
            do {
                let request = try UserRouter.login(query: query).makeRequest()
                
                networkManager.fetchDecodedData(request, model: LoginResponse.self)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let failure) = completion {
                            print(failure)
                        }
                    }, receiveValue: { value in
                        let _ = KeyChainManager.shared.save(key: .accessToken, value: value.token.accessToken)
                        let _ = KeyChainManager.shared.save(key: .refreshToken, value: value.token.refreshToken)
                    })
                    .store(in: &cancellables)
                
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    LoginView()
}
