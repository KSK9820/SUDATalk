//
//  ChannelChattingModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/3/24.
//

import Combine
import SwiftUI

final class ChannelChattingModel: ObservableObject, ChannelChattingModelStateProtocol {
    var cancellables: Set<AnyCancellable> = []
    
    @Published var messageText: String = ""
    @Published var selectedImages: [UIImage] = []
}

extension ChannelChattingModel: ChannelChattingActionsProtocol {}
