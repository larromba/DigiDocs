import Foundation
import Logging
import QuickLook

protocol PDFViewStating {
    var items: [PDFPreviewItem] { get }
    var deleteButtonTitle: String { get }
}

struct PDFViewState: PDFViewStating {
    let items: [PDFPreviewItem]
    let deleteButtonTitle: String = L10n.deleteButtonTitle

    init(paths: [URL]) {
        self.items = paths.compactMap {
            let item = PDFPreviewItem(path: $0)
            if QLPreviewController.canPreview(item) {
                return item
            } else {
                logWarning("can't preview item: \(item)")
                return nil
            }
        }
    }
}
