//
//  CreateChannelModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import Combine
import Foundation

final class CreateChannelModel: ObservableObject, CreateChannelModelStateProtocol {
    var cancellables: Set<AnyCancellable> = []
    private let networkManager = NetworkManager(dataTaskServices: DataTaskServices(), decodedServices: DecodedServices())
    
    @Published var channelName: String = ""
    @Published var description: String = ""
}

extension CreateChannelModel: CreateChannelActionsProtocol {}
