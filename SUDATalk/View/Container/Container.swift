//
//  Container.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Combine
import SwiftUI

final class Container<Intent, Model>: ObservableObject {
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
    
    func binding<Value>(for keyPath: WritableKeyPath<Model, Value>) -> Binding<Value> {
        Binding(
            get: { self.model[keyPath: keyPath] },
            set: { self.model[keyPath: keyPath] = $0 }
        )
    }
}
