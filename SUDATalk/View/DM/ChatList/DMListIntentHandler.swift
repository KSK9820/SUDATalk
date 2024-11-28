//
//  DMListIntentHandler.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import Foundation

final class DMListIntentHandler: IntentProtocol {
    private var model: DMListActionProtocol
    typealias Intent = DMListIntent
    
    init(model: DMListActionProtocol) {
        self.model = model
    }
    
    func handle(intent: DMListIntent) {
        switch intent {
            
        }
    }
    
}

enum DMListIntent: IntentType {
    
}
