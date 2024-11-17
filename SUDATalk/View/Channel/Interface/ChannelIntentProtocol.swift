//
//  IntentProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/17/24.
//

import Foundation

protocol ChannelIntentProtocol {
    associatedtype Action
    
    func action(_ action: Action)
}
