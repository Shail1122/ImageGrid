//
//  DemoAppProjectApp.swift
//  ContentView
//
//  Created by Shailendra Tripathi on 24/10/24.
//
import SwiftUI

// Set the screen width to dynamically calculate grid item sizes
let screenWidth = UIScreen.main.bounds.width

struct ContentView: View {
    @StateObject private var viewModel = ImageViewModel()
    
    // Define a 3-column grid layout with equal spacing between items
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                // LazyVGrid to load grid items only when they appear on screen
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(viewModel.images) { image in
                        // Custom view that asynchronously loads and displays images from helper class
                        AsyncImageView(thumbnail: image.thumbnail)
                        // Set each grid item's height dynamically based on screen width
                            .frame(height: (screenWidth - 40)/3)
                            .cornerRadius(10)
                            .padding(5)
                    }
                }
                .padding(5)
                .background(Color.black.opacity(0.2))
                .cornerRadius(10)
            }
            .navigationTitle(Constants.ImageGrid)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Replace with your actual image name
    }
}
