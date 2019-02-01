import PPBadgeView
import UIKit

// sourcery: name = HomeViewController
protocol HomeViewControlling: Presentable, Mockable {
    var viewState: MainViewStating? { get set }

    func setDelegate(_ delegate: HomeViewControllerDelegate)
}

protocol HomeViewControllerDelegate: AnyObject {
    func viewControllerWillAppear(_ viewController: HomeViewControlling)
    func viewControllerCameraPressed(_ viewController: HomeViewControlling)
    func viewControllerListPressed(_ viewController: HomeViewControlling)
}

final class HomeViewController: UIViewController, HomeViewControlling {
    @IBOutlet private(set) weak var cameraButton: UIButton!
    @IBOutlet private(set) weak var listButton: UIButton!
    @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private(set) weak var appVersionLabel: UILabel!
    private(set) var listBadgeLabel: PPBadgeLabel?
    private weak var delegate: HomeViewControllerDelegate?

    var viewState: MainViewStating? {
        didSet { _ = viewState.map(bind) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = viewState.map(bind)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.viewControllerWillAppear(self)
    }

    func setDelegate(_ delegate: HomeViewControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: - private

    private func bind(_ viewState: MainViewStating) {
        guard isViewLoaded else { return }
        listButton.isEnabled = viewState.isListButtonEnabled
        listButton.pp.addBadge(number: viewState.badgeNumber)
        listButton.pp.setBadgeLabel(attributes: { self.listBadgeLabel = $0 })
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
