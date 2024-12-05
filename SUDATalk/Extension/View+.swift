//
//  View+.swift
//  SUDATalk
//
//  Created by 박다현 on 11/18/24.
//

import SwiftUI

extension View {
    func setRootView(what view: some View) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let rootViewController = UIHostingController(rootView: view)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    func dragGesture(direction: DragDirection,
                     action: @escaping () -> Void) -> some View {
        self.gesture(
            DragGesture()
                .onChanged { value in
                    switch direction {
                    case .left:
                        if value.translation.width < 150 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                action()
                            }
                        }
                    case .right:
                        if value.translation.width > 150 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                action()
                            }
                        }
                    }
                }
        )
    }
}

enum DragDirection {
    case left
    case right
}
