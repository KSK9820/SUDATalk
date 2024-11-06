//
//  ExploreActionsProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/2/24.
//

import Foundation

protocol ExploreActionsProtocol: AnyObject {
    func fetchChennelList(_ workspaceID: String)
    func toggleAlert()
}