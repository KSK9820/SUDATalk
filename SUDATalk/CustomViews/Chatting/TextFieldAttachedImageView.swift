//
//  TextFieldAttachedImageView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import SwiftUI

struct TextFieldAttachedImageView: View {
    var images: [UIImage]
    var onRemoveImage: ((Int) -> Void)?
    
    var body: some View {
        if !images.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                            Button(action: {
                                onRemoveImage?(index)
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Colors.primary)
                                    .background(Colors.white)
                                    .clipShape(Circle())
                                    .offset(x: 5, y: -5)
                            })
                        }
                    }
                }
                .padding(.top, 5)
            }
        }
    }
}
