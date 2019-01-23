import Logging
import UIKit

// sourcery: name = Camera
protocol Camerable: AnyObject, Mockable {
    var isAvailable: Bool { get }

    func setDelegate(_ delegate: CameraDelegate)
    func open(in viewController: Presentable) -> Bool
    func takePicture()
    func dismiss()
}

protocol CameraDelegate: AnyObject {
    func camera(_ camera: Camera, didTakePhoto photo: UIImage)
    func cameraDidCancel(_ camera: Camera)
}

final class Camera: NSObject, Camerable {
    private let pickerType: ImagePickerControlling.Type
    private let picker: ImagePickerControlling
    private weak var delegate: CameraDelegate?
    var isAvailable: Bool {
        return pickerType.isSourceTypeAvailable(.camera)
    }

    init(overlay: UIViewController, pickerType: ImagePickerControlling.Type) {
        self.pickerType = pickerType
        let picker = pickerType.init()
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

    func open(in viewController: Presentable) -> Bool {
        guard isAvailable else {
            logError("camera not available")
            return false
        }
        viewController.present(picker.asViewController, animated: true, completion: nil)
        return true
    }

    func takePicture() {
        picker.takePicture()
    }

    func dismiss() {
        (picker as? UIViewController)?.dismiss(animated: true, completion: nil)
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
