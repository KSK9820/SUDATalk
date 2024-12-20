//
//  ChannelSettingActionProtocol.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import Foundation

protocol ChannelSettingActionProtocol: AnyObject {
    func getChannelInfo()
    func fetchProfileImages(_ url: String, index: Int)
    func exitChannel()
    func editChannel()
    func changeAdmin()
    func deleteChannel()
    func updateChannel(_ channel: ChannelListPresentationModel)
}
