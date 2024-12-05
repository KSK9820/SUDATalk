//
//  LoginIntent.swift
//  SUDATalk
//
//  Created by 박다현 on 12/5/24.
//

import Foundation

final class LoginIntent {
    private weak var model: LoginActionsProtocol?

    init(model: LoginActionsProtocol) {
        self.model = model
    }
}

extension LoginIntent: ChannelIntentProtocol {
    enum Action {
        case tapSubmitButton
    }
    
    func action(_ action: Action) {
        switch action {
        case .tapSubmitButton:
            model?.login()
        }
    }
}

