//
//  NavigationBlackBackButton.swift
//  SUDATalk
//
//  Created by 김수경 on 11/20/24.
//

import SwiftUI

private struct NavigationBlackBackButton: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Images.chevronLeft
                    }
                }
            }
    }
}

extension View {
    func wrapToBackButton() -> some View {
        modifier(NavigationBlackBackButton())
    }
}
