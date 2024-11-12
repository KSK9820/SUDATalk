//
//  InterfaceContainer.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Combine
import Foundation

final class InterfaceContainer<Intent, Model: ModelStateProtocol>: ObservableObject {
    let intent: Intent
    var model: Model

    private var cancellable = Set<AnyCancellable>()

    init(intent: Intent, model: Model, modelChangePublisher: ObjectWillChangePublisher) {
        self.intent = intent
        self.model = model

        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellable)
    }
}
