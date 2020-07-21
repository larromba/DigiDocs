import UIKit

// sourcery: name = CameraController
protocol CameraControlling: Mockable {
    var isPresenting: Bool { get }

    func openCamera()
    func closeCamera(completion: (() -> Void)?)
    func setDelegate(_ delegate: CameraControllerDelegate)
}

protocol CameraControllerDelegate: AnyObject {
    func controller(_ controller: CameraControlling, finishedWithPhotos photos: [UIImage])
    func controller(_ controller: CameraControlling, showAlert alert: Alert)
}

final class CameraController: CameraControlling {
    private let camera: Camerable
    private let cameraOverlay: CameraOverlayViewControlling
    private var photos = [UIImage]()
    private weak var delegate: CameraControllerDelegate?
    private weak var presenter: Presentable?
    var isPresenting: Bool {
        return presenter?.isPresenting ?? false
    }

    init(camera: Camerable, cameraOverlay: CameraOverlayViewControlling, presenter: Presentable) {
        self.camera = camera
        self.cameraOverlay = cameraOverlay
        self.presenter = presenter
        camera.setDelegate(self)
        cameraOverlay.setDelegate(self)
    }

    func openCamera() {
        guard let presenter = presenter, camera.open(in: presenter) else {
            delegate?.controller(self, showAlert: Alert(title: L10n.noCameraAlertTitle))
            return
        }
        cameraOverlay.viewState = CameraViewState(isDoneEnabled: false, numberOfPhotos: 0)
    }

    func setDelegate(_ delegate: CameraControllerDelegate) {
        self.delegate = delegate
    }

    func closeCamera(completion: (() -> Void)?) {
        camera.dismiss(animated: true, completion: completion)
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
            delegate?.controller(self, showAlert: Alert(title: L10n.errorAlertTitle,
                                                        message: L10n.photoNotTakenAlertTitle))
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
        delegate?.controller(self, finishedWithPhotos: photos)
        photos.removeAll()
    }

    func cameraOverlayCancelPressed(_ cameraOverlay: CameraOverlayViewController) {
        delegate?.controller(self, finishedWithPhotos: [])
        photos.removeAll()
    }
}
