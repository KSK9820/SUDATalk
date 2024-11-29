//
//  CircleImageView.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import SwiftUI

private struct CircleImageView: ViewModifier {
    let width: CGFloat
    let height: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.black, lineWidth: 2)
            )
    }
}

extension Image {
    func circleImageStyle(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .modifier(CircleImageView(width: width, height: height))
    }
}
