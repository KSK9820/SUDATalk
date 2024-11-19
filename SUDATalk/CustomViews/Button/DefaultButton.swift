//
//  DefaultButton.swift
//  SUDATalk
//
//  Created by 박다현 on 11/10/24.
//

import SwiftUI

private struct DefaultButton: ViewModifier {
    let action: () -> Void
    @Binding var active: Bool
    
    func body(content: Content) -> some View {
        Button(action: action) {
            HStack {
                Spacer()
                
                content
                    .textStyle(.bodyBold)
                
                Spacer()
            }
            .padding()
            .background(active ? Colors.primary : Colors.inactive)
            .foregroundStyle(active ? Colors.white : Colors.bgPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(maxWidth: .infinity)
        .disabled(!active)
    }
}

extension View {
    func wrapToDefaultButton(active: Binding<Bool>, action: @escaping () -> Void) -> some View {
        modifier(DefaultButton(action: action, active: active))
    }
}
