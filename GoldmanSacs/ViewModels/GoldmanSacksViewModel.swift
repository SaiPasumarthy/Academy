import Foundation
import UIKit
import Combine

class GoldmanSacksViewModel: ObservableObject {
    @Published var items: [GSItems] = []
    @Published var images: [String: UIImage] = [:]
    @Published var isLoading: Bool = false

    private let cacheManager = StorageManagement.shared
    private let folderName = "SpaceImages"
    
    private let url = "https://api.nasa.gov/planetary/apod?api_key=QYGXmxgECyEEQb27KGb2NNYhGApbpIVsLlbwoFbM&count=15"
    
    var dataSubscription: AnyCancellable?
    var imageSubscriptions: [AnyCancellable] = []
    
    init() {
        fetchItems()
    }
    
    func fetchItems() {
        isLoading = true
        guard let url = URL(string: url) else { return }
        
        dataSubscription = NetworkManager.download(url: url)
            .decode(type: [GSItems].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedItems in
                self?.isLoading = false
                self?.items = returnedItems
                self?.getImages(for: returnedItems)
                self?.dataSubscription?.cancel()
                print("Decoded items: \(returnedItems.count)")
            })
    }

    private func getImages(for items: [GSItems]) {
        for item in items {
            if let savedImage = cacheManager.getImage(imageName: item.title ?? "default", folderName: folderName) {
                images[item.url ?? ""] = savedImage
            }
            // Don't download immediately - wait for lazy loading
        }
    }
    
    func loadImageIfNeeded(for item: GSItems) {
        guard let urlString = item.url else { return }
        guard images[urlString] == nil else { return } // already loaded or downloading
        
        // Check cache first
        if let cachedImage = cacheManager.getImage(imageName: item.title ?? "default", folderName: folderName) {
            images[urlString] = cachedImage
            return
        }
        
        // Download only when visible
        downloadImage(for: item)
    }
    
    func downloadImage(for item: GSItems) {
        print("Downloading images...")
        guard let urlString = item.url else { return }
        guard images[urlString] == nil else { return } // already downloaded
        guard let url = URL(string: urlString) else { return }
        
        // Create a new subscription for each image
        let subscription = NetworkManager.download(url: url)
            .tryMap({ data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create UIImage from data"])
                }
                return image
            })
            .sink(receiveCompletion: { [weak self] completion in
                NetworkManager.handleCompletion(completion: completion)
            }, receiveValue: { [weak self] returnedImage in
                self?.images[urlString] = returnedImage
                self?.cacheManager.saveImage(image: returnedImage, imageName: item.title ?? "default", folderName: self?.folderName ?? "")
            })
        
        // Store the subscription so it doesn't get deallocated
        imageSubscriptions.append(subscription)
    }
    
    func getImage(for item: GSItems) -> UIImage? {
        guard let url = item.url else { return nil }
        return images[url]
    }
    
    func getParsedDate(for item: GSItems) -> Date {
        guard let ds = item.date else { return Date() }
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        return df.date(from: ds) ?? Date()
    }
}
