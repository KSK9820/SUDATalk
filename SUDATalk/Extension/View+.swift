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
}
