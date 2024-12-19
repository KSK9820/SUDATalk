//
//  CacheManager.swift
//  SUDATalk
//
//  Created by 박다현 on 11/8/24.
//

import UIKit

final class CacheManager {
    static let shared = CacheManager()
    private let cache = NSCache<NSString, NSData>()

    private init() {}
    
    func saveToCache(data: Data, forKey key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func loadFromCache(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
    
    func removeFromCache(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}
