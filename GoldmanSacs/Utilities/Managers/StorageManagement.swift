import UIKit
import Foundation

class StorageManagement {
    static let shared = StorageManagement()
    
    private let cacheDirectoryName = "ImageCache"
    
    private init() { }

    func saveImage(image: UIImage, imageName: String, folderName: String) {

        createFolderIfNeeded(folderName: folderName)

        guard let data = image.pngData(),
        let url = getURLForImage(imageName: imageName, folderName: folderName) else { return }
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName), Error: \(error)")
        }
    }

    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard 
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    private func createFolderIfNeeded(folderName: String) {
        guard let folderURL = getURLForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating folder. FolderName: \(folderName), Error: \(error)")
            }
        }
    }

    private func getURLForFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        guard let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL =  getURLForFolder(folderName: folderName) else { return nil }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
}

