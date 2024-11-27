//
//  ImageConverter.swift
//  SUDATalk
//
//  Created by 박다현 on 11/7/24.
//

import UIKit

final class ImageConverter {
    static let shared = ImageConverter()
    
    private var maxSizeMB: Double = 7.0
    private var compressionQuality: CGFloat = 1.0
    
    private init() {}
    
    func configure(maxSizeMB: Double, compressionQuality: CGFloat = 1.0) {
        self.maxSizeMB = maxSizeMB
        self.compressionQuality = compressionQuality
    }
    
    func convertToData(images: [UIImage]) -> [Data] {
        var imageDataArray: [Data] = []
        
        for image in images {
            var imageData = image.jpegData(compressionQuality: self.compressionQuality)
            
            while let data = imageData, Double(data.count) / (1024 * 1024) > maxSizeMB, compressionQuality > 0.1 {
                compressionQuality -= 0.1
                imageData = image.jpegData(compressionQuality: compressionQuality)
            }
            
            if let data = imageData, Double(data.count) / (1024 * 1024) > maxSizeMB {
                print("이미지가 용량을 초과합니다.")
                continue
            }
            
            guard let imageData else { return [Data()] }
            imageDataArray.append(imageData)
        }
        
        return imageDataArray
    }
    
    func convertToData(image: UIImage) -> Data {
        var imageData = image.jpegData(compressionQuality: self.compressionQuality)
        
        while let data = imageData, Double(data.count) / (1024 * 1024) > maxSizeMB, compressionQuality > 0.1 {
            compressionQuality -= 0.1
            imageData = image.jpegData(compressionQuality: compressionQuality)
        }
        
        if let data = imageData, Double(data.count) / (1024 * 1024) > maxSizeMB {
            print("이미지가 용량을 초과합니다.")
        }
        
        guard let imageData else { return Data() }
        
        return imageData
    }
}
