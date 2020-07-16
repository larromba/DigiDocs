import AsyncAwait
import UIKit

// sourcery: name = PDFController
protocol PDFControlling: Mockable {
    func deletePDFs(at paths: [URL]) -> Async<Void, Error>
    func makePDF(fromPhotos photos: [UIImage], withName name: String) -> Async<Void, Error>
}

final class PDFController: PDFControlling {
    private let viewController: PDFViewControlling
    private let alertController: AlertControlling
    private let pdfAlertController: AlertControlling
    private let presenter: Presentable
    private let pdfService: PDFServicing
    private let fileManager: FileManager

    init(viewController: PDFViewControlling, alertController: AlertControlling, pdfAlertController: AlertControlling,
         presenter: Presentable, pdfService: PDFServicing, fileManager: FileManager = .default) {
        self.viewController = viewController
        self.alertController = alertController
        self.pdfAlertController = pdfAlertController
        self.presenter = presenter
        self.pdfService = pdfService
        self.fileManager = fileManager

        let list = pdfService.generateList()
        viewController.viewState = PDFViewState(paths: list.paths)
        viewController.setDelegate(self)
    }

    func deletePDFs(at paths: [URL]) -> Async<Void, Error> {
        return deletePDFs(at: paths, alertController: alertController)
    }

    func makePDF(fromPhotos photos: [UIImage], withName name: String) -> Async<Void, Error> {
        return Async { completion in
            async({
                let pdf = PDF(images: photos, name: name)
                try await(self.pdfService.generatePDF(pdf))
                onMain {
                    self.viewController.viewState = PDFViewState(paths: [pdf.path])
                    self.presenter.present(self.viewController.asViewController, animated: true, completion: nil)
                }
                completion(.success(()))
            }, onError: { error in
                completion(.failure(error))
            })
        }
    }

    // MARK: - private

    private func deletePDFs(at paths: [URL], alertController: AlertControlling) -> Async<Void, Error> {
        return Async { completion in
            let alert = Alert(
                title: L10n.warningAlertTitle,
                message: L10n.areYouSureAlertTitle,
                cancel: Alert.Action(title: L10n.noButtonTitle, handler: nil),
                actions: [Alert.Action(title: L10n.yesButtonTitle, handler: {
                    async({
                        try await(self._deletePDFs(at: paths))
                        completion(.success(()))
                    }, onError: { error in
                        completion(.failure(error))
                    })
                })],
                textField: nil
            )
            onMain { alertController.showAlert(alert) }
        }
    }

    private func _deletePDFs(at paths: [URL]) -> Async<Void, Error> {
        return Async { completion in
            var errors = [URL: Error]()
            paths.forEach {
                do {
                    try self.fileManager.removeItem(at: $0)
                } catch {
                    errors[$0] = error
                }
            }
            guard errors.isEmpty else {
                let error = errors.first!
                completion(.failure(PDFError.framework(error.value)))
                return
            }
            completion(.success(()))
        }
    }
}

// MARK: - PDFViewControllerDelegate

extension PDFController: PDFViewControllerDelegate {
    func viewController(_ viewController: PDFViewController, deleteItem item: PDFPreviewItem) {
        async({
            guard let url = item.previewItemURL else { return }
            try await(self.deletePDFs(at: [url], alertController: self.pdfAlertController))
            onMain { self.viewController.viewState = PDFViewState(paths: self.pdfService.generateList().paths) }
        }, onError: { error in
            onMain { self.alertController.showAlert(Alert(error: error)) }
        })
    }
}
