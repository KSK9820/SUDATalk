//
//  BorderButton.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import SwiftUI

private struct BorderButton: ViewModifier {
    let color: Color
    let action: () -> Void
    
    func body(content: Content) -> some View {
        Button(action: action) {
            HStack {
                Spacer()
                
                content
                    .textStyle(.bodyBold)
                
                Spacer()
            }
            .padding()
            .background(Colors.white)
            .foregroundStyle(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity)
    }
}

extension View {
    func wrapToBorderButton(_ color: Color, action: @escaping () -> Void) -> some View {
        modifier(BorderButton(color: color, action: action))
    }
}
