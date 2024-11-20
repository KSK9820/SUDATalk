//
//  ImageCacheManager.swift
//  SUDATalk
//
//  Created by 박다현 on 11/8/24.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let imageCache = NSCache<NSString, NSData>()

    private init() {}
    
    func saveImageToCache(imageData: Data, forKey key: String) {
        imageCache.setObject(imageData as NSData, forKey: key as NSString)
    }
    
    func loadImageFromCache(forKey key: String) -> Data? {
        return imageCache.object(forKey: key as NSString) as Data?
    }
}
