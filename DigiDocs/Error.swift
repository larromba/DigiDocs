import Foundation

enum CameraError: Error {
    case orientation
}

enum PDFError: Error {
    case context
    case noContent
    case framework(Error)
}
