//
//  AyncImageView.swift
//  DemoAppProject
//
//  Created by Shailendra Tripathi on 24/10/24.


import SwiftUI

// ImageCache is a singleton class that manages a shared NSCache instance to store images with their URL as the key
class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}

// AsyncImageView is a custom SwiftUI view that asynchronously loads and displays an image from a URL
struct AsyncImageView: View {
    let thumbnail: MyImageDataModel.Thumbnail
    @State private var uiImage: UIImage? = nil
    @State private var isLoading = false

    var body: some View {

        // Construct the image URL string using the thumbnail's properties
        let imageUrl = "\(thumbnail.domain)/\(thumbnail.basePath)/0/\(thumbnail.key.rawValue)"

        if let url = URL(string: imageUrl) {
            // First, check if the image is already cached
            if let cachedImage = ImageCache.shared.object(forKey: url as NSURL) {
                // Use cached image if available
                Image(uiImage: cachedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .onAppear {
                        print(Constants.cacheImage)
                    }
            } else {
                // If the image is not cached, show a placeholder while loading
                if isLoading {
                    ProgressView()
                } else {
                    // Start loading the image when the view appears
                    Color.clear
                        .onAppear {
                            print("Loading image from URL: \(url)")
                            loadImage(from: url)
                        }
                }
            }
        } else {
            // If the URL is invalid, display an error icon
            Image(systemName: Constants.errorImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.red) // Red color to indicate an error
                .clipped()
        }
    }

    private func loadImage(from url: URL) {
        guard !isLoading else { return }
        isLoading = true // Set loading state to true when starting the fetch the data

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                // Cache the image
                ImageCache.shared.setObject(image, forKey: url as NSURL)
                // Update the UI on the main thread after loading the image
                DispatchQueue.main.async {
                    self.uiImage = image
                    self.isLoading = false
                }
            } else {
                // If there is an error, update the loading state to false on the main thread
                DispatchQueue.main.async {
                    self.isLoading = false // Stop loading if there's an error
                }
            }
        }
        task.resume()
    }
}

