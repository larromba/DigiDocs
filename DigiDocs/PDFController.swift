import UIKit

protocol PDFControlling {
    func deletePDFs(at paths: [URL])
    func makePDF(fromPhotos photos: [UIImage], withName name: String)
}

final class PDFController: PDFControlling {
    private let viewController: PDFViewControlling
    private let alertController: AlertControlling
    private let presenter: Presentable
    private let pdfService: PDFServicing
    private let fileManager: FileManager

    init(viewController: PDFViewControlling, alertController: AlertControlling, presenter: Presentable,
         pdfService: PDFServicing, fileManager: FileManager = .default) {
        self.viewController = viewController
        self.alertController = alertController
        self.presenter = presenter
        self.pdfService = pdfService
        self.fileManager = fileManager

        let list = pdfService.generateList()
        viewController.viewState = PDFViewState(paths: list.paths)
        viewController.setDelegate(self)
    }

    func deletePDFs(at paths: [URL]) {
        let alert = Alert(
            title: L10n.warningAlertTitle,
            message: L10n.areYouSureAlertTitle,
            cancel: Alert.Action(title: L10n.noButtonTitle, handler: nil),
            actions: [Alert.Action(title: L10n.yesButtonTitle, handler: {
                self.delete(paths)
            })],
            textField: nil
        )
        alertController.showAlert(alert)
    }

    func makePDF(fromPhotos photos: [UIImage], withName name: String) {
        let pdf = PDF(images: photos, name: name)
        pdfService.generatePDF(pdf, { _ in
            self.viewController.viewState = PDFViewState(paths: [pdf.path])
            // TODO: !
            self.presenter.present(self.viewController as! UIViewController, animated: true, completion: nil)
        })
    }

    // MARK: - private

    private func delete(_ paths: [URL]) {
        var errors = [URL: Error]()
        paths.forEach {
            do {
                try fileManager.removeItem(at: $0)
            } catch {
                errors[$0] = error
            }
        }
        if errors.isEmpty {
            let list = pdfService.generateList()
            viewController.viewState = PDFViewState(paths: list.paths)
        } else {
            let error = errors.first!
            // TODO: this will work?
            let title = L10n.deleteErrorAlertTitle(error.key.absoluteString, error.value.localizedDescription)
            alertController.showAlert(Alert(title: title))
        }
    }
}

// MARK: - PDFViewControllerDelegate

extension PDFController: PDFViewControllerDelegate {
    func viewController(_ viewController: PDFViewController, deleteItem item: PDFPreviewItem) {
        guard let url = item.previewItemURL else { return }
        deletePDFs(at: [url])
    }
}
