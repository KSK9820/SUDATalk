//
//  SystemImageButton.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import SwiftUI

struct SystemImageButton: View {
    var systemImage: Image
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                systemImage
                Text(text)
            }
        }
    }
}
