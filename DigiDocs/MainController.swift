import UIKit

protocol MainControlling {
    var presenter: Presentable { get }

    func setDelegate(_ delegate: MainControllerDelegate)
    func updatedPDFList()
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
            isUserInteractionEnabled: true,
            isListButtonEnabled: !list.paths.isEmpty
        )
        viewController.setDelegate(self)
    }

    func setDelegate(_ delegate: MainControllerDelegate) {
        self.delegate = delegate
    }

    func updatedPDFList() {
        let list = pdfService.generateList()
        viewController.viewState = viewController.viewState?.copy(isListButtonEnabled: !list.paths.isEmpty)
    }
}

// MARK: - MainViewControllerDelegate

extension MainController: MainViewControllerDelegate {
    func viewControllerCameraPressed(_ viewController: MainViewControlling) {
        delegate?.controller(self, performAction: .openCamera)
    }

    func viewControllerListPressed(_ viewController: MainViewControlling) {
        delegate?.controller(self, performAction: .openList)
    }
}
