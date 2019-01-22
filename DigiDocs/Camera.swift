import Logging
import UIKit

protocol Camerable: AnyObject {
    var isAvailable: Bool { get }

    func open(in viewController: Presentable, completion: (() -> Void)?)
    func takePicture()
    func dismiss()
}

protocol CameraDelegate: AnyObject {
    func camera(_ camera: Camera, didTakePhoto photo: UIImage)
    func cameraDidCancel(_ camera: Camera)
}

final class Camera: NSObject, Camerable {
    private let picker: UIImagePickerController
    private weak var delegate: CameraDelegate?
    var isAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    init(overlay: UIViewController) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.showsCameraControls = false
        picker.cameraOverlayView = overlay.view
        let screenSize = UIScreen.main.bounds.size
        let ratio: CGFloat = 4.0 / 3.0
        let cameraHeight = screenSize.width * ratio
        picker.cameraViewTransform = CGAffineTransform(translationX: 0, y: (screenSize.height - cameraHeight) / 4.0)
        // full screen
        //        let scale = screenSize.height / cameraHeight
        //        picker.cameraViewTransform = picker.cameraViewTransform.scaledBy(x: scale, y: scale)
        self.picker = picker
        super.init()
        picker.delegate = self
    }

    func setDelegate(_ delegate: CameraDelegate) {
        self.delegate = delegate
    }

    func open(in viewController: Presentable, completion: (() -> Void)? = nil) {
        guard isAvailable else {
            // TODO: return error
            logError("camera not available")
            return
        }
        viewController.present(picker, animated: true, completion: {
            completion?()
        })
    }

    func takePicture() {
        picker.takePicture()
    }

    func dismiss() {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension Camera: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let photo = info[.originalImage] as? UIImage else {
            assertionFailure("missing \(UIImagePickerController.InfoKey.originalImage)")
            return
        }
        delegate?.camera(self, didTakePhoto: photo)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.cameraDidCancel(self)
    }
}
