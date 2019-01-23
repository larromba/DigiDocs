import Foundation

struct PDFList {
    let paths: [URL]
}

extension PDFList {
    func contains(_ name: String) -> Bool {
        let filteredPaths = paths.filter { $0.lastPathComponent == "\(name).\(FileExtension.pdf.rawValue)" }
        return !filteredPaths.isEmpty
    }
}
