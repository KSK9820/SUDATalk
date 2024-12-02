//
//  ContentSize.swift
//  SUDATalk
//
//  Created by 김수경 on 12/3/24.
//

import Foundation

import UIKit

enum ContentSize {
    static var screenWidth: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds.size.width
        }
        return UIScreen.main.bounds.size.width
    }
    static var screenHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds.size.height
        }
        return UIScreen.main.bounds.size.height
    }

    case workspaceScreen
}

extension ContentSize {
    var size: CGSize {
        switch self {
        case .workspaceScreen:
            return CGSize(width: ContentSize.screenWidth * 0.85, height: 0)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
