//
//  ImageFileManager.swift
//  SUDATalk
//
//  Created by 박다현 on 11/8/24.
//

import UIKit

final class ImageFileManager{
    static let shared = ImageFileManager()
    private init() {}
    
    func saveImageToDocument(image: UIImage, fileUrl: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else {
            print("Failed to get document directory")
            return
        }
        
        let modifiedPath = fileUrl.split(separator: "/")
        let folderURL = documentDirectory.appendingPathComponent("\(modifiedPath[0])/\(modifiedPath[1])")
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
               do {
                   try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                   print("created directory: \(folderURL.path)")
               } catch {
                   print("failed to create directory: \(error)")
                   return
               }
           }
        
        let fileURL = folderURL.appendingPathComponent("\(modifiedPath[2])")
        let imageData = ImageConverter.shared.convertToData(image: image)
        
        do {
            try imageData.write(to: fileURL)
        } catch {
            print("failed to save: \(error)")
        }
    }

    func loadFile(fileUrl: String) -> Data? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(fileUrl)")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                return try Data(contentsOf: fileURL)
            } catch {
                print("failed to load: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func removeImageFromDocument(filename: String) {
        DispatchQueue.global().async {
            guard let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else { return }

            let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                } catch {
                    print("file remove error", error)
                }
            } else {
                print("file no exist")
            }
        }
    }
    
    func removeAllImagesFromDocument() {
        DispatchQueue.global().async {
            guard let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else { return }

            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
                
                for fileURL in fileURLs {
                    if fileURL.pathExtension == "jpg" {
                        do {
                            try FileManager.default.removeItem(at: fileURL)
                        } catch {
                            print("Failed to delete file: \(fileURL.lastPathComponent), error: \(error)")
                        }
                    }
                }
            } catch {
                print("Error fetching files from document directory: \(error)")
            }
        }
    }
}
