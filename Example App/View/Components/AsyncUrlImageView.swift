//
//  AsyncUrlImageView.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 13/01/25.
//

import SwiftUI
import Combine

fileprivate class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

fileprivate class ImageLoader: ObservableObject {
    
    private var cancellable: AnyCancellable?
    @Published private(set) var image: UIImage?
    @Published private(set) var didFail: Bool = false
    @Published private(set) var isLoading: Bool = false
    private var urlString: String?
    
    func loadImage(from urlString: String) {
        self.urlString = urlString
        if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        
        self.isLoading = true
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(_) = completion {
                    self?.didFail = true
                }
            } receiveValue: { [weak self] data in
                if let downloadedImage = UIImage(data: data) {
                    ImageCache.shared.setObject(downloadedImage, forKey: urlString as NSString)
                    self?.image = downloadedImage
                    self?.didFail = false
                }
            }
    }
}

struct AsyncUrlImageView<Content: View, FailContent: View>: View {
    
    @StateObject private var imageLoader: ImageLoader = .init()
    
    private let imageUrl: String
    private let imageResult: (Image) -> Content
    private let failResult: (Image) -> FailContent
    
    init(_ imageUrl: String, imageResult: @escaping (Image) -> Content, failResult: @escaping (Image) -> FailContent) {
        self.imageUrl = imageUrl
        self.imageResult = imageResult
        self.failResult = failResult
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if let image = imageLoader.image {
                imageResult(Image(uiImage: image))
            } else {
                if imageLoader.didFail {
                    failResult(Image(systemName: "photo"))
                }
                if imageLoader.isLoading {
                    ProgressView()
                }
            }
        }
        .onAppear {
            imageLoader.loadImage(from: imageUrl)
        }
    }
}
