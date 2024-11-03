//
//  ChatCellView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import SwiftUI

struct ChatCellView: View {
    let image: Image
    let userName: String
    let message: String
    let images: [Image]
    let time: String
    
    var body: some View {
        HStack(alignment: .top) {
            image
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.trailing, 8)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(userName)
                        .textStyle(.body)
                        .foregroundColor(Colors.textPrimary)
                    
                    Text(message)
                        .textStyle(.body)
                        .padding(12)
                        .foregroundColor(Colors.textPrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Colors.gray, lineWidth: 1)
                        )
                    
                    VStack(spacing: 3) {
                        if !images.isEmpty {
                            HStack(spacing: 3) {
                                ForEach(0..<min(images.count, 3), id: \.self) { index in
                                    images[index]
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            
                            if images.count > 3 {
                                HStack(spacing: 3) {
                                    ForEach(3..<min(images.count, 5), id: \.self) { index in
                                        images[index]
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Text(time)
                    .textStyle(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
