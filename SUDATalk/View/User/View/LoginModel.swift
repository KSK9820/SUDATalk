//
//  LoginModel.swift
//  SUDATalk
//
//  Created by 박다현 on 12/5/24.
//

import Combine
import Foundation

final class LoginModel: ObservableObject, LoginModelStateProtocol {
    private var cancellables: Set<AnyCancellable> = []
    private let networkManager = NetworkManager()
    private let repository = ChannelChatRepository()

    @Published var userID: String = "suda@sesac.com"
    @Published var userPW: String = "Ssesac1234@@"
    @Published var loginSuccessful: Bool = false
}

extension LoginModel: LoginActionsProtocol {
    func login() {
        let query = LoginQuery(email: userID, password: userPW, deviceToken: "")
        
        do {
            let request = try UserRouter.login(query: query).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: LoginResponse.self)
                .sink(receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                }, receiveValue: { [weak self] value in
                    guard let self else { return }
                    KeyChainManager.shared.save(key: .accessToken, value: value.token.accessToken)
                    KeyChainManager.shared.save(key: .refreshToken, value: value.token.refreshToken)
                    
                    UserDefaultsManager.shared.userProfile = value.convertToModel()
                    print(UserDefaultsManager.shared.workspace.workspaceID)
                    if let profileImage = value.profileImage {
                        loadProfileImage(profileImage)
                    }
                    
                    loginSuccessful = true
                })
                .store(in: &cancellables)
            
        } catch {
            print(error)
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
