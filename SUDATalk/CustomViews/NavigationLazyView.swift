//
//  NavigationLazyView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let title: String?
    let build: () -> Content
    
    var body: some View {
        if let title {
            build()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        } else {
            build()
        }
    }
    
    init(title: String? = nil, _ build: @autoclosure @escaping () -> Content) {
        self.title = title
        self.build = build
    }
}
