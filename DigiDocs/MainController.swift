import UIKit

// sourcery: name = MainController
protocol MainControlling: Mockable {
    var presenter: Presentable { get }

    func setIsLoading(_ isLoading: Bool)
    func setDelegate(_ delegate: MainControllerDelegate)
    func refreshUI()
}

protocol MainControllerDelegate: AnyObject {
    func controller(_ controller: MainControlling, performAction action: MainAction)
}

final class MainController: MainControlling {
    private let viewController: MainViewControlling
    private let pdfService: PDFServicing
    private weak var delegate: MainControllerDelegate?

    var presenter: Presentable {
        return viewController
    }

    init(viewController: MainViewControlling, pdfService: PDFServicing) {
        self.viewController = viewController
        self.pdfService = pdfService

        let list = pdfService.generateList()
        viewController.viewState = MainViewState(
            isLoading: false,
            isListButtonEnabled: !list.paths.isEmpty
        )
        viewController.setDelegate(self)
    }

    func setIsLoading(_ isLoading: Bool) {
        viewController.viewState = viewController.viewState?.copy(isLoading: isLoading)
    }

    func setDelegate(_ delegate: MainControllerDelegate) {
        self.delegate = delegate
    }

    func refreshUI() {
        let list = pdfService.generateList()
        viewController.viewState = viewController.viewState?.copy(isListButtonEnabled: !list.paths.isEmpty)
    }
}

// MARK: - MainViewControllerDelegate

extension MainController: MainViewControllerDelegate {
    func viewControllerWillAppear(_ viewController: MainViewControlling) {
        refreshUI()
    }

    func viewControllerCameraPressed(_ viewController: MainViewControlling) {
        delegate?.controller(self, performAction: .openCamera)
    }

    func viewControllerListPressed(_ viewController: MainViewControlling) {
        delegate?.controller(self, performAction: .openList)
    }
}
