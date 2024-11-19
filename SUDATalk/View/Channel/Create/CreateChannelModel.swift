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
    private let networkManager = NetworkManager()
    
    @Published var channelID: String? = ""
    @Published var channelName: String = ""
    @Published var description: String = ""
    @Published var activeSubmit: Bool = false
    @Published var isEditMode: Bool = false
    @Published var modifiedChannel: ChannelListPresentationModel?
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
            
            networkManager.getDecodedDataTaskPublisher(request, model: ChannelListResponse.self)
                .sink { completion in
                    if case .failure(let error) = completion {
                        if let networkError = error as? NetworkAPIError {
                            switch networkError {
                            case .E12:
                                print("중복된 이름")
                            default:
                                break
                            }
                        }
                    }
                    
                } receiveValue: { value in
                    print(value)
                }
                .store(in: &cancellables)

        } catch {
            print(error)
        }
    }
    
    func editChannel(_ workspaceID: String, input: ChannelInput) {
        do {
            var query = ChannelQuery(name: "", description: nil, image: nil)
            if let image = input.image {
                let imageData = ImageConverter.shared.convertToData(image: image)
                query = ChannelQuery(name: input.name, description: input.description, image: imageData)
            } else {
                query = ChannelQuery(name: input.name, description: input.description, image: nil)
            }
            
            guard let channelID else { return }
            let request = try ChannelRouter.editChannel(workspaceID: workspaceID, channelID: channelID, query: query).makeRequest()

            networkManager.getDecodedDataTaskPublisher(request, model: ChannelListResponse.self)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                        if let networkError = error as? NetworkAPIError {
                            switch networkError {
                            case .E12:
                                print("중복된 이름")
                            default:
                                break
                            }
                        }
                    }
                } receiveValue: { [weak self] value in
                    print(value)
                    self?.modifiedChannel = value.convertToModel()
                }
                .store(in: &cancellables)

        } catch {
            print(error)
        }
    }
}
