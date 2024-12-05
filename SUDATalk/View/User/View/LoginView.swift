//
//  LoginView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Combine
import SwiftUI

struct LoginView: View {
    private let networkManager = NetworkManager()
    
    @State var cancellables = Set<AnyCancellable>()
    @AppStorage("userID") var userID: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Button {
                    setRootView(what: CustomTabView(workspace: SampleTest.workspace))
                } label: {
                    Text("이동")
                }
            }
        }
        .task {
            let query = SampleTest.user1
            
            do {
                let request = try UserRouter.login(query: query).makeRequest()
                
                networkManager.getDecodedDataTaskPublisher(request, model: LoginResponse.self)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let failure) = completion {
                            print(failure)
                        }
                    }, receiveValue: { value in
                        userID = value.user_id
                        KeyChainManager.shared.save(key: .accessToken, value: value.token.accessToken)
                        KeyChainManager.shared.save(key: .refreshToken, value: value.token.refreshToken)
                        
                        UserDefaultsManager.shared.userProfile = value.convertToModel()
                        
                        if let profileImage = value.profileImage {
                            loadProfileImage(profileImage)
                        }
                    })
                    .store(in: &cancellables)
                
            } catch {
                print(error)
            }
        }
    }
    
    private func loadProfileImage(_ url: String) {
        do {
            let request = try UserRouter.fetchImage(url: url).makeRequest()
            
            networkManager.getDataTaskPublisher(request)
                .sink { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                } receiveValue: { value in
                    CacheManager.shared.saveToCache(data: value, forKey: url)
                    UserDefaultsManager.shared.userProfile.profileImageData = value
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
}

#Preview {
    LoginView()
}
