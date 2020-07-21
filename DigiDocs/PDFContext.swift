import UIKit

struct PDFContext {
    var photos: [UIImage]?
    var name: String?
    var currentPDF: PDF? {
        guard let photos = photos, let name = name else { return nil }
        return PDF(images: photos, name: name)
    }

    mutating func reset() {
        photos = nil
        name = nil
    }
}
