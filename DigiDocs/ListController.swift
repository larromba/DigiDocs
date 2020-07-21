import Foundation

// sourcery: name = ListController
protocol ListControlling: Mockable {
    var documentCount: Int { get }
    var all: PDFList { get }

    func openList(_ list: PDFList)
}

final class ListController: ListControlling {
    private let pdfService: PDFServicing
    private let presenter: Presentable

    var documentCount: Int {
        return all.paths.count
    }
    var all: PDFList {
        return pdfService.generateList()
    }

    init(presenter: Presentable, pdfService: PDFServicing) {
        self.presenter = presenter
        self.pdfService = pdfService
    }

    func openList(_ list: PDFList) {
        let viewController = PDFViewController(viewState: PDFViewState(paths: list.paths))
        presenter.present(viewController, animated: true, completion: nil)
    }
}
