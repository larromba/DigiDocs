import AsyncAwait
import Logging
import UIKit

// sourcery: name = HomeController
protocol HomeControlling: Mockable {
    func setIsLoading(_ isLoading: Bool)
    func setDelegate(_ delegate: HomeControllerDelegate)
    func refreshBadge()
}

protocol HomeControllerDelegate: AnyObject {
    func controller(_ controller: HomeControlling, performAction action: HomeAction)
}

final class HomeController: HomeControlling {
    private let viewController: HomeViewControlling
    private let pdfService: PDFServicing
    private let badge: Badge
    private weak var delegate: HomeControllerDelegate?

    init(viewController: HomeViewControlling, pdfService: PDFServicing, badge: Badge) {
        self.viewController = viewController
        self.pdfService = pdfService
        self.badge = badge

        viewController.viewState = MainViewState(isLoading: false, badgeNumber: 0)
        viewController.setDelegate(self)
    }

    func setIsLoading(_ isLoading: Bool) {
        viewController.viewState = viewController.viewState?.copy(isLoading: isLoading)
    }

    func setDelegate(_ delegate: HomeControllerDelegate) {
        self.delegate = delegate
    }

    func refreshBadge() {
        let badgeNumber = pdfService.generateList().paths.count
        viewController.viewState = viewController.viewState?.copy(badgeNumber: badgeNumber)
        async({
            try await(self.badge.setNumber(badgeNumber))
        }, onError: { error in
            logError(error.localizedDescription)
        })
    }
}

// MARK: - MainViewControllerDelegate

extension HomeController: HomeViewControllerDelegate {
    func viewControllerWillAppear(_ viewController: HomeViewControlling) {
        refreshBadge()
    }

    func viewControllerCameraPressed(_ viewController: HomeViewControlling) {
        delegate?.controller(self, performAction: .openCamera)
    }

    func viewControllerListPressed(_ viewController: HomeViewControlling) {
        delegate?.controller(self, performAction: .openList)
    }
}
