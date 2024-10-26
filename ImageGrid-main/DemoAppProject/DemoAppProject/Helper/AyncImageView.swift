//
//  AyncImageView.swift
//  DemoAppProject
//
//  Created by Shailendra Tripathi on 24/10/24.


import SwiftUI

// AsyncImageView is a custom SwiftUI view that asynchronously loads and displays an image from a URL
struct AsyncImageView: View {
    let thumbnail: MyImageDataModel.Thumbnail
    @State private var uiImage: UIImage? = nil
    @State private var isLoading = false

    var body: some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else if isLoading {
                ProgressView()
            } else {
                Color.clear.onAppear {
                    loadImage()
                }
            }
        }
        .onAppear {
            if uiImage == nil {
                loadImage()
            }
        }
    }

    private func loadImage() {
        // Construct the image URL string using the thumbnail's properties
        let imageUrl = "\(thumbnail.domain)/\(thumbnail.basePath)/0/\(thumbnail.key.rawValue)"
        
        guard let url = URL(string: imageUrl) else {
            print("Invalid URL")
            uiImage = UIImage(systemName: Constants.errorImage)
            return
        }
        
        let urlKey = url as NSURL
        
        // Check memory cache first
        if let cachedImage = ImageCache.shared.object(forKey: urlKey) {
            uiImage = cachedImage
            print("Loaded image from memory cache")
            return
        }
        
        // Check disk cache if not in memory, and update memory cache if found
        DispatchQueue.global(qos: .background).async {
            if let diskImage = ImageCache.getImageFromDisk(forKey: urlKey) {
                DispatchQueue.main.async {
                    ImageCache.shared.setObject(diskImage, forKey: urlKey) // Update memory cache
                    uiImage = diskImage
                    print("Loaded image from disk cache and updated memory cache")
                }
                return
            }
            
            // Download the image if not cached
            isLoading = true
            print("Loading image from URL: \(url)")
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        ImageCache.shared.setObject(image, forKey: urlKey)
                        ImageCache.saveImageToDisk(image, forKey: urlKey)
                        uiImage = image
                        isLoading = false
                        print("Loaded image from URL and cached it to both memory and disk")
                    }
                } else {
                    DispatchQueue.main.async {
                        uiImage = UIImage(systemName: Constants.errorImage)
                        isLoading = false
                        print("Failed to load image from URL")
                    }
                }
            }.resume()
        }
    }
}
