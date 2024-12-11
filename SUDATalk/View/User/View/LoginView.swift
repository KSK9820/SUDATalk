//
//  LoginView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var container: Container<LoginIntent, LoginModelStateProtocol>
    private let networkManager = NetworkManager()

    @State private var isButtonActive: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Images.logo
                    .resizable()
                    .frame(width: 264, height: 50)
                
                Images.readyToMake
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                TextField("이메일을 입력하세요.", text: container.binding(for: \.userID))
                    .padding(12)
                    .background(Colors.white)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Colors.inactive, lineWidth: 1)
                    )
                
                SecureField("비번를 입력하세요.", text: container.binding(for: \.userPW))
                    .padding(12)
                    .background(Colors.white)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Colors.inactive, lineWidth: 1)
                    )
                
                Text("로그인 하기")
                    .wrapToDefaultButton(active: $isButtonActive) {
                        container.intent.action(.tapSubmitButton)
                    }
                    .padding(.vertical)
            }
            .padding(.horizontal, 30)
        }
        .onChange(of: container.model.userID) { _ in
            updateSubmitButtonState()
        }
        .onChange(of: container.model.userPW) { _ in
            updateSubmitButtonState()
        }
        .onChange(of: container.model.loginSuccessful) { value in
            if value {
                setRootView(what: CustomTabView(workspace: UserDefaultsManager.shared.workspace.coverToPresentationModel()))
            }
        }
        .onAppear {
            updateSubmitButtonState()
        }
    }
    
    private func updateSubmitButtonState() {
        let value = !container.model.userID.isEmpty && !container.model.userPW.isEmpty
        isButtonActive = value
    }
}

extension LoginView {
    static func build() -> some View {
        let model = LoginModel()
        let intent = LoginIntent(model: model)
        
        let container = Container(
            intent: intent,
            model: model as LoginModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return LoginView(container: container)
    }
}
