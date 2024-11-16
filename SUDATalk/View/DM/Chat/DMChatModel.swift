//
//  DMChatModel.swift
//  SUDATalk
//
//  Created by 김수경 on 11/5/24.
//

import Combine
import SwiftUI
import UIKit

final class DMChatModel: ObservableObject, ModelStateProtocol {
    private let networkManager = NetworkManager()
    private let socketManager = SocketIOManager(event: DMSocketEvent(roomID: SampleTest.roomID))
    private var cancellables = Set<AnyCancellable>()
    
    @Published var messageText: String = ""
    @Published var selectedImages: [Data] = []
}

extension DMChatModel: ModelActionProtocol {
    func sendMessage(query: DMChatQuery) {
        do {
            let request = try DMRouter.chats(workspaceID: SampleTest.workspaceID, roomID: SampleTest.roomID, body: query).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: DMChatResponse.self)
                .sink { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                } receiveValue: { value in
                    print(value)
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func connectSocket() {
        socketManager.connect()
    }
    
    func disconnectSocket() {
        socketManager.disconnect()
    }
}
