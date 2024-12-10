//
//  HomeModel.swift
//  SUDATalk
//
//  Created by 박다현 on 12/2/24.
//

import Combine
import Foundation

final class HomeModel: ObservableObject, HomeModelStateProtocol {
    private let networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    var workspace: WorkspacePresentationModel
    
    @Published var dmlist: [DMRoomInfoPresentationModel] = []

    init(workspace: WorkspacePresentationModel) {
        self.workspace = workspace
    }
}

extension HomeModel: HomeActionsProtocol {
    func getDMList() {
        do {
            let request = try DMRouter.dmlist(workspaceID: workspace.workspaceID).makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: [DMRoomInfoResponse].self)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self]  value in
                    guard let self else { return }
                    
                    dmlist = value.map { $0.convertToModel() }
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
}
