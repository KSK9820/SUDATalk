//
//  LoginView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import Combine
import SwiftUI

struct LoginView: View {
    @State var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .padding()
        .task {
            let query = SampleTest.login
            
            do {
                let request = try UserRouter.login(query: query).makeRequest()
                
                NetworkManager(dataTaskServices: DataTaskServices(), decodedServices: DecodedServices()).fetchDecodedData(request, model: LoginResponse.self)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let failure) = completion {
                            print(failure)
                        }
                    }, receiveValue: { returnedItem in
                        print("Returned Item: \(returnedItem)")
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
