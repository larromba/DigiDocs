import UIKit

// sourcery: name = CameraController
protocol CameraControlling: Mockable {
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
    private let overlayAlertController: AlertControlling
    private var photos = [UIImage]()
    private weak var delegate: CameraControllerDelegate?

    init(camera: Camerable, cameraOverlay: CameraOverlayViewControlling, alertController: AlertControlling,
         overlayAlertController: AlertControlling) {
        self.camera = camera
        self.cameraOverlay = cameraOverlay
        self.alertController = alertController
        self.overlayAlertController = overlayAlertController

        camera.setDelegate(self)
        cameraOverlay.setDelegate(self)
    }

    func openCamera(in presenter: Presentable) {
        guard camera.open(in: presenter) else {
            alertController.showAlert(Alert(title: L10n.noCameraAlertTitle))
            return
        }
        cameraOverlay.viewState = CameraViewState(isDoneEnabled: false, numberOfPhotos: 0)
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
        #if !targetEnvironment(simulator)
        // right    0
        // down     90 CW
        // left     180
        // up       90 CCW
        guard photo.imageOrientation == .right else {
            // this is a weird edge case - it seems a bug in iOS's framework that causes the imageOrientation
            // to mess up
            overlayAlertController.showAlert(Alert(title: L10n.errorAlertTitle, message: L10n.photoNotTakenAlertTitle))
            return
        }
        #endif
        photos.append(photo)
        cameraOverlay.viewState = cameraOverlay.viewState?.copy(isDoneEnabled: !photos.isEmpty,
                                                                numberOfPhotos: photos.count)
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
        photos.removeAll()
    }
}
