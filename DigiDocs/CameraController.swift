import UIKit

protocol CameraControlling {
    func openCamera(in presenter: Presentable)
    func setDelegate(_ delegate: CameraControllerDelegate)
}

protocol CameraControllerDelegate: AnyObject {
    func controller(_ controller: CameraController, finishedWithPhotos photos: [UIImage])
}

final class CameraController: CameraControlling {
    private let camera: Camerable
    private let cameraOverlay: CameraOverlayViewControlling
    private let alertController: AlertControlling
    private var photos = [UIImage]()
    private weak var delegate: CameraControllerDelegate?

    init(camera: Camerable, cameraOverlay: CameraOverlayViewControlling, alertController: AlertControlling) {
        self.camera = camera
        self.cameraOverlay = cameraOverlay
        self.alertController = alertController
        cameraOverlay.setDelegate(self)
    }

    func openCamera(in presenter: Presentable) {
        guard camera.isAvailable else {
            alertController.showAlert(Alert(title: L10n.noCameraAlertTitle))
            return
        }
        camera.open(in: presenter, completion: nil)
    }

    func setDelegate(_ delegate: CameraControllerDelegate) {
        self.delegate = delegate
    }
}

// MARK: - CameraDelegate

extension CameraController: CameraDelegate {
    func cameraDidCancel(_ camera: Camera) {
        photos.removeAll()
    }

    func camera(_ camera: Camera, didTakePhoto photo: UIImage) {
        // right    0
        // down     90 CW
        // left     180
        // up       90 CCW
        guard photo.imageOrientation == .right else {
            // this is a weird edge case - it seems a bug in iOS's framework that causes the imageOrientation
            // to mess up
            alertController.showAlert(Alert(title: L10n.errorAlertTitle, message: L10n.photoNotTakenAlertTitle))
            return
        }
        photos.append(photo)
    }
}

// MARK: - CameraOverlayViewControllerDelegate

extension CameraController: CameraOverlayViewControllerDelegate {
    func cameraOverlayTakePressed(_ cameraOverlay: CameraOverlayViewController) {
        camera.takePicture()
    }

    func cameraOverlayDonePressed(_ cameraOverlay: CameraOverlayViewController) {
        camera.dismiss()
        delegate?.controller(self, finishedWithPhotos: photos)
        photos.removeAll()
    }

    func cameraOverlayCancelPressed(_ cameraOverlay: CameraOverlayViewController) {
        camera.dismiss()
    }
}
