import CoreGraphics
import Foundation

protocol CameraViewStating {
    var takeButtonTitle: String { get }
    var doneButtonTitle: String { get }
    var cancelButtonTitle: String { get }
    var isDoneEnabled: Bool { get }
    var doneButtonAlpha: CGFloat { get }
}

struct CameraViewState: CameraViewStating {
    let takeButtonTitle: String = L10n.takeButtonTitle
    let doneButtonTitle: String = L10n.doneButtonTitle
    let cancelButtonTitle: String = L10n.cancelButtonTitle
    let isDoneEnabled: Bool
    var doneButtonAlpha: CGFloat {
        return isDoneEnabled ? 1.0 : 0.3
    }
}
