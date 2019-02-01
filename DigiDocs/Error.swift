import Foundation

enum CameraError: Error {
    case orientation
}

enum PDFError: LocalizedError {
    case context
    case noContent
    case framework(Error)

    var errorDescription: String? {
        return L10n.foobarAlertTitle
    }
}
