//
//  WorkspaceModel.swift
//  SUDATalk
//
//  Created by 김수경 on 12/5/24.
//

import Combine
import SwiftUI

final class WorkspaceModel: ObservableObject, WorkspaceModelStateProtocol {
    private let networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isShowWorkspace: Bool = false
    @Published var workspaceStatus: WorkSpaceStatus = .loading
    @Published var workspaceList = [WorkspacePresentationModel]()
    @Published var isLoaded = false
}

extension WorkspaceModel: WorkspaceActionsProtocol {
    func hideWorkspace() {
        isShowWorkspace = false
    }
    
    func showWorkspace() {
        isShowWorkspace = true
    }
    
    func setDisappear() {
        isLoaded = false
    }
    
    func getWorkspaceList() {
        do {
            let request = try WorkspaceRouter.workspaceList.makeRequest()
            
            networkManager.getDecodedDataTaskPublisher(request, model: [WorkspaceResponse].self)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self]  value in
                    guard let self else { return }
                    
                    let convertedData = value.map { $0.converToModel() }
                    let covertedWorkspaceID = Set(value.map { $0.workspaceID })
                    let originWorkspaceID = Set(workspaceList.map { $0.workspaceID })
                    if covertedWorkspaceID != originWorkspaceID {
                        workspaceList = convertedData
                        workspaceStatus = workspaceList.count == 0 ? .none : .more
                    }
                    isLoaded = true
                }
                .store(in: &cancellables)
            
        } catch {
            print(error)
        }
    }
    
    func fetchThumbnail(_ url: String, idx: Int) {
        do {
            let request = try WorkspaceRouter.fetchImage(url: url).makeRequest()
            
            networkManager.getCachingImageDataTaskPublisher(request: request, key: url)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    guard let self else { return }
                    
                    if let uiImage = UIImage(data: value) {
                        self.workspaceList[idx].coverImageData = uiImage
                    }
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
}

