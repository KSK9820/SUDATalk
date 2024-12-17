//
//  TextStyle.swift
//  SUDATalk
//
//  Created by 박다현 on 11/1/24.
//

import SwiftUI

enum TextStyle {
    case title1
    case title2
    case title3
    case bodyBold
    case body
    case caption
}

extension TextStyle {
    var font: Font {
        switch self {
        case .title1:
            return .system(size: 23, weight: .bold, design: .default)
        case .title2:
            return .system(size: 14, weight: .bold, design: .default)
        case .title3:
            return .system(size: 16, weight: .regular, design: .default)
        case .bodyBold:
            return .system(size: 13, weight: .bold, design: .default)
        case .body:
            return .system(size: 13, weight: .regular, design: .default)
        case .caption:
            return .system(size: 12, weight: .regular, design: .default)
        }
    }
    
    var lineSpacing: CGFloat {
        switch self {
        case .title1:
            return 30 - 22
        case .title2, .title3:
            return 20 - 14
        case .bodyBold, .body:
            return 18 - 13
        case .caption:
            return 18 - 12
        }
    }
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self
            .font(style.font)
            .lineSpacing(style.lineSpacing)
    }
}
