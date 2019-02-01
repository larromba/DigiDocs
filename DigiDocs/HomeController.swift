import UIKit

// sourcery: name = HomeController
protocol HomeControlling: Mockable {
    var presenter: Presentable { get }

    func setIsLoading(_ isLoading: Bool)
    func setDelegate(_ delegate: HomeControllerDelegate)
    func refreshUI()
}

protocol HomeControllerDelegate: AnyObject {
    func controller(_ controller: HomeControlling, performAction action: MainAction)
}

final class HomeController: HomeControlling {
    private let viewController: HomeViewControlling
    private let pdfService: PDFServicing
    private weak var delegate: HomeControllerDelegate?

    var presenter: Presentable {
        return viewController
    }

    init(viewController: HomeViewControlling, pdfService: PDFServicing) {
        self.viewController = viewController
        self.pdfService = pdfService

        let list = pdfService.generateList()
        viewController.viewState = MainViewState(isLoading: false, badgeNumber: list.paths.count)
        viewController.setDelegate(self)
    }

    func setIsLoading(_ isLoading: Bool) {
        viewController.viewState = viewController.viewState?.copy(isLoading: isLoading)
    }

    func setDelegate(_ delegate: HomeControllerDelegate) {
        self.delegate = delegate
    }

    func refreshUI() {
        let list = pdfService.generateList()
        viewController.viewState = viewController.viewState?.copy(badgeNumber: list.paths.count)
    }
}

// MARK: - MainViewControllerDelegate

extension HomeController: HomeViewControllerDelegate {
    func viewControllerWillAppear(_ viewController: HomeViewControlling) {
        refreshUI()
    }

    func viewControllerCameraPressed(_ viewController: HomeViewControlling) {
        delegate?.controller(self, performAction: .openCamera)
    }

    func viewControllerListPressed(_ viewController: HomeViewControlling) {
        delegate?.controller(self, performAction: .openList)
    }
}
