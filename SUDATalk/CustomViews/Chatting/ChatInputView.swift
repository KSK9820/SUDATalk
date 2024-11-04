//
//  ChatInputView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import SwiftUI

struct ChatInputView: View {
    @Binding var messageText: String
    @Binding var selectedImages: [UIImage]
    
    var onRemoveImage: ((Int) -> Void)?
    var sendButtonTap: (() -> Void)?
    
    var body: some View {
        HStack {
            PhotoPicker(selectedImages: $selectedImages) {
                Image("plus")
            }
            
            VStack {
                TextField("메시지를 입력하세요", text: $messageText, axis: .vertical)
                    .frame(minHeight: 35)
                    .padding(5)
                
                TextFieldAttachedImageView(images: selectedImages, onRemoveImage: { index in
                    selectedImages.remove(at: index)
                })
                .padding(.bottom, 5)
            }
            
            Button(action: {
                sendButtonTap?()
            }, label: {
                Image("message")
            })
            
        }
        .padding(.horizontal)
        .background(Colors.gray)
        .cornerRadius(15)
        .padding()
    }
}
