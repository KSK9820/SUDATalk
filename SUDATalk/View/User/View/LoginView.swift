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
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                NavigationLink("이동") {
                    CreateChannelView.build()
                }
            }
        }
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
                        KeyChainManager.shared.save(key: .accessToken, value: value.token.accessToken)
                        KeyChainManager.shared.save(key: .refreshToken, value: value.token.refreshToken)
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
