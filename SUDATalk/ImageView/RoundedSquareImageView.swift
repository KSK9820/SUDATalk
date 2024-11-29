//
//  RoundedSquareImageView.swift
//  SUDATalk
//
//  Created by 김수경 on 11/28/24.
//

import SwiftUI

private struct RoundedSquareImageView: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension Image {
    func roundedImageStyle(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .modifier(RoundedSquareImageView(width: width, height: height, cornerRadius: 8))
    }
}
