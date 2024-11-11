//
//  InterfaceContainer.swift
//  SUDATalk
//
//  Created by 박다현 on 11/11/24.
//

import Combine
import Foundation

final class InterfaceContainer<Intent, Model>: ObservableObject {
    let intent: Intent
    var model: Model

    private var cancellable: Set<AnyCancellable> = []

    init(intent: Intent, model: Model, modelChangePublisher: ObjectWillChangePublisher) {
        self.intent = intent
        self.model = model

        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellable)
    }
}

