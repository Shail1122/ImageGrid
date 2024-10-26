//
//  AyncImageView.swift
//  DemoAppProject
//
//  Created by Shailendra Tripathi on 24/10/24.


import SwiftUI
import Combine

struct AsyncImageView: View {
    let thumbnail: MyImageDataModel.Thumbnail
    @State private var uiImage: UIImage? = nil
    @State private var isLoading = false
    @State private var cancellable: AnyCancellable?

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
                Color.clear
                    .onAppear {
                        startLoading()
                    }
                    .onDisappear {
                        // Cancel only if the view is no longer visible and not yet loaded
                        if !isLoading {
                            cancelLoading()
                        }
                    }
            }
        }
    }

    private func startLoading() {
        guard uiImage == nil else { return }
        
        // Construct the image URL string using the thumbnail's properties
        let imageUrl = "\(thumbnail.domain)/\(thumbnail.basePath)/0/\(thumbnail.key.rawValue)"
        guard let url = URL(string: imageUrl) else {
            print("Invalid URL")
            uiImage = UIImage(systemName: Constants.errorImage)
            return
        }

        let urlKey = url as NSURL

        // First, check memory cache
        if let cachedImage = ImageCache.shared.object(forKey: urlKey) {
            uiImage = cachedImage
            print("Loaded image from memory cache")
            return
        }
        
        // Proceed to load the image
        isLoading = true
        cancellable = loadImage(from: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    self.uiImage = UIImage(systemName: Constants.errorImage)
                }
                self.isLoading = false
            }, receiveValue: { image in
                ImageCache.shared.setObject(image, forKey: urlKey)
                ImageCache.saveImageToDisk(image, forKey: urlKey)
                self.uiImage = image
                print("Loaded image and cached to memory and disk")
            })
    }

    private func loadImage(from url: URL) -> AnyPublisher<UIImage, Error> {
        // Check disk cache
        if let diskImage = ImageCache.getImageFromDisk(forKey: url as NSURL) {
            ImageCache.shared.setObject(diskImage, forKey: url as NSURL) // Update memory cache
            return Just(diskImage)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        // Download the image
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background)) // Background queue for downloading
            .tryMap { data, response in
                guard let image = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                return image
            }
            .eraseToAnyPublisher()
    }

    private func cancelLoading() {
        cancellable?.cancel()
        cancellable = nil
        isLoading = false
        print("Cancelled image loading task")
    }
}
