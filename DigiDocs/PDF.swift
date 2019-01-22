import UIKit

struct PDF {
    let images: [UIImage]
    let path: URL

    init(images: [UIImage], name: String, fileManager: FileManager = .default) {
        self.images = images
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last else {
            // TODO: how to handle?
            path = URL(fileURLWithPath: "file://")
            return
        }
        path = documentsPath.appendingPathComponent("\(name)").appendingPathExtension(FileExtension.pdf.rawValue)
    }
}
