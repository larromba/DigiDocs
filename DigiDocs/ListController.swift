import Foundation

// TODO: remove L10n.noDocumentsAlertTitle

protocol ListControlling {
    var documentCount: Int { get }
    var list: PDFList { get }

    func openList(_ list: PDFList)
}

final class ListController: ListControlling {
    private let alertController: AlertControlling
    private let pdfService: PDFServicing
    private let presenter: Presentable

    var documentCount: Int {
        return list.paths.count
    }
    var list: PDFList {
        return pdfService.generateList()
    }

    init(alertController: AlertControlling, presenter: Presentable, pdfService: PDFServicing) {
        self.alertController = alertController
        self.presenter = presenter
        self.pdfService = pdfService
    }

    func openList(_ list: PDFList) {
        let viewController = PDFViewController(viewState: PDFViewState(paths: list.paths))
        presenter.present(viewController, animated: true, completion: nil)
    }
}
