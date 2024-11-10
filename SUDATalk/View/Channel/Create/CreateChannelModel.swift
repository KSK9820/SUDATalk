//
//  CreateChannelModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/4/24.
//

import Combine
import Foundation

final class CreateChannelModel: ObservableObject, CreateChannelModelStateProtocol {
    private var cancellables: Set<AnyCancellable> = []
    private let networkManager = NetworkManager(dataTaskServices: DataTaskServices(), decodedServices: DecodedServices())
    
    @Published var channelName: String = ""
    @Published var description: String = ""
    @Published var activeSubmit: Bool = false
}

extension CreateChannelModel: CreateChannelActionsProtocol {
    func createChannel(_ workspaceID: String, input: ChannelInput) {
        do {
            var query = ChannelQuery(name: "", description: nil, image: nil)
            if let image = input.image {
                let imageData = ImageConverter.shared.convertToData(image: image)
                query = ChannelQuery(name: input.name, description: input.description, image: imageData)
            } else {
                query = ChannelQuery(name: input.name, description: input.description, image: nil)
            }
            
            let request = try ChannelRouter.createChannel(workspaceID: workspaceID, query: query).makeRequest()
            
            networkManager.fetchDecodedData(request, model: ChannelResponse.self)
                .sink { error in
                    print(error)
                } receiveValue: { value in
                    print(value)
                }
                .store(in: &cancellables)

        } catch {
            print(error)
        }
    }
}
