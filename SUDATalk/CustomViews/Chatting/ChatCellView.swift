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
    let images: [Data]
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
                            let imageCount = images.count
                            let imageSpacing = 3.0
                            let columnsInRow = 3
                            let firstLineImageWidth = getImageWidth(imageCount: imageCount, spacing: imageSpacing, columns: columnsInRow)
                            let secondLineImageWidth = getImageWidth(imageCount: imageCount - columnsInRow, spacing: imageSpacing, columns: columnsInRow)
                            
                            if !images.isEmpty {
                                HStack(spacing: imageSpacing) {
                                    ForEach(0..<min(imageCount, columnsInRow), id: \.self) { index in
                                        if let convertedImage = UIImage(data: images[index]) {
                                            Image(uiImage: convertedImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: firstLineImageWidth, height: firstLineImageWidth)
                                                .clipped()
                                        }
                                    }
                                }
                                
                                if images.count > columnsInRow {
                                    HStack(spacing: imageSpacing) {
                                        ForEach(columnsInRow..<min(images.count, imageCount), id: \.self) { index in
                                            if let uiImage = UIImage(data: images[index]) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: secondLineImageWidth, height: secondLineImageWidth)
                                                    .clipped()
                                            }
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

    private func getImageWidth(imageCount: Int, spacing: CGFloat, columns: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 160
        let imageWidth = screenWidth / CGFloat(min(imageCount, columns)) - CGFloat(min(imageCount, columns) - 1) * spacing
        
        return imageWidth
    }
}
