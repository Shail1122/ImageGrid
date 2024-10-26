#  ImageGridLoader

Project Description

This iOS application efficiently loads and displays images in a scrollable grid using SwiftUI. The project demonstrates optimal image handling with native SwiftUI components while ensuring smooth scrolling and minimal memory usage. This project avoids any third-party image loading libraries and meets the requirement for native SwiftUI-only solutions.

Features

Displays images in a scrollable grid.
Efficient loading and caching of images.
Fully implemented using SwiftUI.
Adaptive layout that adjusts grid size based on device orientation and screen size.

Requirements

Xcode: Version 13 or later
iOS: iOS 14.0 or later
Swift: 5.3 or later

Implementation Details

1. Grid Layout
LazyVGrid is used to efficiently render a scrollable grid of images.
The grid layout adapts dynamically to screen size and orientation.
2. Image Loading
URLSession is used to download images asynchronously.
@StateObject and @Published are used to manage the image states, ensuring smooth loading.
Images are cached using in-memory caching to avoid redundant network requests, improving performance.
3. Caching Mechanism
A simple image caching strategy is implemented within ImageLoader.swift to store downloaded images in memory. This ensures smoother scrolling by reusing previously loaded images instead of fetching them from the network repeatedly.

4. Error Handling
Placeholder images are displayed while the actual images are being fetched.
If an image fails to load, an error icon or retry button can be shown.


Usage

Launch the app, and you will see a grid of images fetched from the network.
Scroll through the grid; images will load as they come into view.
Images are cached for a smoother experience on subsequent loads.

Author

[Shailendra Tripathi]
