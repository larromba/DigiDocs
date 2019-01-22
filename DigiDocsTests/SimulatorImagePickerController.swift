import UIKit

class SimulatorImagePickerController: UIImagePickerController {
    override var sourceType: UIImagePickerController.SourceType { get { return .camera } set {} }
    override var showsCameraControls: Bool { get { return true } set {} }
    override var cameraOverlayView: UIView? { get { return nil } set {} }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override class func isSourceTypeAvailable(_ sourceType: UIImagePickerController.SourceType) -> Bool {
        return true
    }
}
