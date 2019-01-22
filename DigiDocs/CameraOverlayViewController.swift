import UIKit

protocol CameraOverlayViewControlling {
    var viewState: CameraViewStating? { get set }

    func setDelegate(_ delegate: CameraOverlayViewControllerDelegate)
}

protocol CameraOverlayViewControllerDelegate: AnyObject {
    func cameraOverlayTakePressed(_ cameraOverlay: CameraOverlayViewController)
    func cameraOverlayDonePressed(_ cameraOverlay: CameraOverlayViewController)
    func cameraOverlayCancelPressed(_ cameraOverlay: CameraOverlayViewController)
}

final class CameraOverlayViewController: UIViewController, CameraOverlayViewControlling {
    @IBOutlet private(set) weak var takeButton: UIButton!
    @IBOutlet private(set) weak var doneButton: UIButton!
    @IBOutlet private(set) weak var cancelButton: UIButton!
    private weak var delegate: CameraOverlayViewControllerDelegate?

    var viewState: CameraViewStating? {
        didSet { _ = viewState.map(bind) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = viewState.map(bind)
    }

    func setDelegate(_ delegate: CameraOverlayViewControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: - private

    private func bind(_ viewState: CameraViewStating) {
        guard isViewLoaded else { return }
        takeButton.setTitle(viewState.takeButtonTitle, for: .normal)
        doneButton.setTitle(viewState.doneButtonTitle, for: .normal)
        cancelButton.setTitle(viewState.cancelButtonTitle, for: .normal)
        doneButton.isEnabled = viewState.isDoneEnabled
        doneButton.alpha = viewState.doneButtonAlpha
    }

    // MARK: - action

    @IBAction private func takeButtonPressed(sender: UIButton) {
        delegate?.cameraOverlayTakePressed(self)
    }

    @IBAction private func cancelButtonPressed(sender: UIButton) {
        delegate?.cameraOverlayCancelPressed(self)
    }

    @IBAction private func doneButtonPressed(sender: UIButton) {
        delegate?.cameraOverlayDonePressed(self)
    }
}
