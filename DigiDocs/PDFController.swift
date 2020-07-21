import AsyncAwait
import UIKit

// sourcery: name = PDFController
protocol PDFControlling: Mockable {
    var isPresenting: Bool { get }

    func showPDF(_ pdf: PDF)
    func showDeleteDialogue(for pdfPaths: [URL])
    func setDelegate(_ delegate: PDFControllerDelegate)
}

protocol PDFControllerDelegate: AnyObject {
    func controller(_ controller: PDFControlling, showAlert: Alert)
    func controller(_ controller: PDFControlling, didDeleteItemsAtPaths: [URL])
    func controller(_ controller: PDFControlling, didShow: Bool, pdf: PDF)
}

final class PDFController: PDFControlling {
    private let viewController: PDFViewControlling
    private let presenter: Presentable
    private let pdfService: PDFServicing
    private let fileManager: FileManager
    private weak var delegate: PDFControllerDelegate?
    var isPresenting: Bool {
        return presenter.isPresenting
    }

    init(viewController: PDFViewControlling, presenter: Presentable, pdfService: PDFServicing,
         fileManager: FileManager = .default) {
        self.viewController = viewController
        self.presenter = presenter
        self.pdfService = pdfService
        self.fileManager = fileManager

        let list = pdfService.generateList()
        viewController.viewState = PDFViewState(paths: list.paths)
        viewController.setDelegate(self)
    }

    func setDelegate(_ delegate: PDFControllerDelegate) {
        self.delegate = delegate
    }

    func showPDF(_ pdf: PDF) {
        async({
            try await(self.pdfService.generatePDF(pdf))
            onMain {
                self.viewController.viewState = PDFViewState(paths: [pdf.path])
                self.presenter.present(self.viewController.casted, animated: true, completion: {
                    self.delegate?.controller(self, didShow: true, pdf: pdf)
                })
            }
        }, onError: { error in
            onMain {
                self.delegate?.controller(self, didShow: false, pdf: pdf)
                self.delegate?.controller(self, showAlert: Alert(error: error))
            }
        })
    }

    func showDeleteDialogue(for pdfPaths: [URL]) {
        let confirm = Alert.Action(title: L10n.yesButtonTitle, handler: {
            if let error = self.deleteItems(at: pdfPaths) {
                self.delegate?.controller(self, showAlert: Alert(error: error))
            } else {
                self.viewController.viewState = PDFViewState(paths: self.pdfService.generateList().paths)
                self.delegate?.controller(self, didDeleteItemsAtPaths: pdfPaths)
            }
        })
        let alert = Alert(
            title: L10n.warningAlertTitle,
            message: L10n.areYouSureAlertTitle,
            cancel: Alert.Action(title: L10n.noButtonTitle, handler: nil),
            actions: [confirm],
            textField: nil
        )
        delegate?.controller(self, showAlert: alert)
    }

    // MARK: - private

    private func deleteItems(at paths: [URL]) -> PDFError? {
        var errors = [URL: Error]()
        paths.forEach {
            do {
                try self.fileManager.removeItem(at: $0)
            } catch {
                errors[$0] = error
            }
        }
        return errors.isEmpty ? nil : .framework(errors.first!.value)
    }
}

// MARK: - PDFViewControllerDelegate

extension PDFController: PDFViewControllerDelegate {
    func viewController(_ viewController: PDFViewController, deleteItem item: PDFPreviewItem) {
        guard let url = item.previewItemURL else { return }
        showDeleteDialogue(for: [url])
    }
}
