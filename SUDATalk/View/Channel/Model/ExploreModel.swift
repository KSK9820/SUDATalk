//
//  ChannelExploreModel.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Combine
import Foundation

// 1
final class ListModel: ObservableObject, ListModelStateProtocol {
    var cancellables: Set<AnyCancellable> = []
    
    @Published var text: String = ""
}

// 2
extension ListModel: ListModelActionsProtocol {
    
    
    func parse(number: Int) {
        text = "Random number: " + String(number)
    }
    
    func postData() {
        let urlString = "http://slp1.sesac.co.kr:39093/v1/users/validation/email"

        NetworkManager.shared.postItem(to: urlString, item: EmailQuery(email: "sesac@sesac.com"))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Item posted successfully.")
                case .failure(let error):
                    print("Error posting item: \(error)")
                }
            }, receiveValue: { returnedItem in
                print("Returned Item: \(returnedItem)")
            })
            .store(in: &cancellables)
    }
}
