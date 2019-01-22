import UIKit

protocol MainViewControlling: Presentable {
    var viewState: MainViewStating? { get set }

    func setDelegate(_ delegate: MainViewControllerDelegate)
}

protocol MainViewControllerDelegate: AnyObject {
    func viewControllerCameraPressed(_ viewController: MainViewControlling)
    func viewControllerListPressed(_ viewController: MainViewControlling)
}

// TODO: rename
final class MainViewController: UIViewController, MainViewControlling {
    @IBOutlet private(set) weak var cameraButton: UIButton!
    @IBOutlet private(set) weak var listButton: UIButton!
    @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private(set) weak var appVersionLabel: UILabel!

    private weak var delegate: MainViewControllerDelegate?

    var viewState: MainViewStating? {
        didSet { _ = viewState.map(bind) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = viewState.map(bind)
    }

    func setDelegate(_ delegate: MainViewControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: - private

    private func bind(_ viewState: MainViewStating) {
        guard isViewLoaded else { return }
        listButton.isEnabled = viewState.isListButtonEnabled
        appVersionLabel.text = viewState.appVersion
        if viewState.isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        view.isUserInteractionEnabled = viewState.isUserInteractionEnabled
    }

    // MARK: - action

    @IBAction private func cameraPressed(_ sender: UIButton) {
        delegate?.viewControllerCameraPressed(self)
    }

    @IBAction private func listPressed(_ sender: UIButton) {
        delegate?.viewControllerListPressed(self)
    }
}
