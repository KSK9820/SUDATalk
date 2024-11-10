//
//  IntentProtocol.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Foundation

protocol IntentProtocol {
    associatedtype Intent: IntentType
    
    func handle(intent: Intent)
}
