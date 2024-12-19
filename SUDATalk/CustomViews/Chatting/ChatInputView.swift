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
    @State private var buttonColor: Color = .gray
    
    var onRemoveImage: ((Int) -> Void)?
    var sendButtonTap: (() -> Void)?
    
    var body: some View {
        HStack {
            PhotoPicker(selectedImages: $selectedImages) {
                Images.plus
            }
            inputTextSection()
            sendButton()
        }
        .padding(.horizontal)
        .background(Colors.gray)
        .cornerRadius(15)
        .padding()
    }
    
    private func inputTextSection() -> some View {
        VStack {
            TextField("메시지를 입력하세요", text: $messageText, axis: .vertical)
                .frame(minHeight: 35)
                .padding(5)
            
            TextFieldAttachedImageView(images: selectedImages, onRemoveImage: { index in
                selectedImages.remove(at: index)
            })
            .padding(.bottom, 5)
        }
    }
    
    private func sendButton() -> some View {
        Button(action: {
            sendButtonTap?()
        }, label: {
            Images.message
                .foregroundColor(buttonColor)
        })
        .onChange(of: messageText) { _ in
            updateButtonColor()
        }
        .onChange(of: selectedImages) { _ in
            updateButtonColor()
        }
    }
    
    private func updateButtonColor() {
        if !messageText.isEmpty || !selectedImages.isEmpty {
            buttonColor = Colors.primary
        } else {
            buttonColor = Colors.inactive
        }
    }
}
