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
    let message: String?
    let images: [Image?]
    let time: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            image
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack(alignment: .bottom, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(userName)
                        .textStyle(.body)
                        .foregroundColor(Colors.textPrimary)
                    
                    if let message = message, !message.isEmpty {
                        Text(message)
                            .textStyle(.body)
                            .padding(12)
                            .foregroundColor(Colors.textPrimary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Colors.gray, lineWidth: 1)
                            )
                    }
                    
                    VStack(spacing: 3) {
                        let imageCount = images.count
                        let imageSpacing = 3.0
                        let columnsInRow = 3
                        let firstLineImageWidth = getImageWidth(imageCount: imageCount, spacing: imageSpacing, columns: columnsInRow)
                        let secondLineImageWidth = getImageWidth(imageCount: imageCount - columnsInRow, spacing: imageSpacing, columns: columnsInRow)
                        
                        if !images.isEmpty {
                            HStack(spacing: imageSpacing) {
                                ForEach(0..<min(imageCount, columnsInRow), id: \.self) { index in
                                    if let messageImage = images[index] {
                                        messageImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: firstLineImageWidth, height: firstLineImageWidth)
                                            .clipped()
                                    } else {
                                        Images.help
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
                                        if let messageImage = images[index] {
                                            messageImage
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: secondLineImageWidth, height: secondLineImageWidth)
                                                .clipped()
                                        } else {
                                            Images.help
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
                    .padding(.bottom, 8)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
    
    private func getImageWidth(imageCount: Int, spacing: CGFloat, columns: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 160
        let imageWidth = (screenWidth - CGFloat(min(imageCount, columns) - 1) * spacing) / CGFloat(min(imageCount, columns))
        
        return imageWidth
    }
}
