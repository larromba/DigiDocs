import Foundation

enum CameraError: Error {
    case orientation
}

// TODO: localize?
enum PDFError: Error {
    case context
    case noContent
    case framework(Error)
}
