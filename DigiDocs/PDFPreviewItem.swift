import QuickLook

final class PDFPreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
    var previewItemTitle: String? {
        return previewItemURL?.lastPathComponent
    }

    init(path: URL) {
        self.previewItemURL = path
        super.init()
    }
}
