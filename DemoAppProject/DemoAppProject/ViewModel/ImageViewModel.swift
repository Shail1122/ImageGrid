//
//  ImageViewModel.swift
//  DemoAppProject
//
//  Created by Shailendra Tripathi on 24/10/24.
//

import Combine
import Foundation

// ImageViewModel is an ObservableObject that manages a list of images
class ImageViewModel: ObservableObject {
    @Published var images: [MyImageDataModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadImages()
    }
    // Function to load images from a remote URL
    func loadImages() {
        guard let url = URL(string: Constants.imageUrl) else {
            return
        }
        // Create a data task to fetch data from the URL
        URLSession.shared.dataTaskPublisher(for: url)
        // Extract the data from the response
            .map { $0.data }
            .decode(type: [MyImageDataModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.images, on: self)
            .store(in: &cancellables)
    }
}
