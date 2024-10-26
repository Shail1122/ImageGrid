//
//  ImageCache.swift
//  DemoAppProject
//
//  Created by Shailendra Tripathi on 24/10/24.
//

import SwiftUI
import Combine

// ImageCache is a singleton class that manages a shared NSCache instance to store images with their URL as the key
class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
    
    // Disk cache directory
    private static let diskCacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent("ImageCache")
    }()

    // Saves the image to disk with a unique file name based on the URL
    static func saveImageToDisk(_ image: UIImage, forKey key: NSURL) {
        let fileURL = diskCacheDirectory.appendingPathComponent(key.absoluteString ?? UUID().uuidString)
        DispatchQueue.global(qos: .background).async {
            if let data = image.pngData() {
                try? data.write(to: fileURL, options: .atomic)
            }
        }
    }

    // Retrieves the image from disk cache if available
    static func getImageFromDisk(forKey key: NSURL) -> UIImage? {
        let fileURL = diskCacheDirectory.appendingPathComponent(key.absoluteString ?? UUID().uuidString)
        return UIImage(contentsOfFile: fileURL.path)
    }
}

