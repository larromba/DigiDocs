import Logging
import UIKit

struct PDF {
    let images: [UIImage]
    let path: URL

    init(images: [UIImage], name: String, fileManager: FileManager = .default) {
        self.images = images
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            path = URL(fileURLWithPath: "file://")
            logError("couldn't find documentDirectory")
            return
        }
        path = documentsPath.appendingPathComponent("\(name)").appendingPathExtension(FileExtension.pdf.rawValue)
    }
}
