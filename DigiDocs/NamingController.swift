import AsyncAwait
import Foundation

// sourcery: name = NamingController
protocol NamingControlling: Mockable {
    func getName() -> Async<String>
}

final class NamingController: NamingControlling {
    private let alertController: AlertControlling
    private let pdfService: PDFServicing

    init(alertController: AlertControlling, pdfService: PDFServicing) {
        self.alertController = alertController
        self.pdfService = pdfService
    }

    func getName() -> Async<String> {
        return Async { completion in
            let list = self.pdfService.generateList()
            var name: String?
            let alert = Alert(
                title: L10n.newDocumentAlertTitle,
                message: L10n.newDocumentAlertMessage,
                cancel: Alert.Action(title: L10n.cancelButtonTitle, handler: nil),
                actions: [Alert.Action(title: L10n.okButtonTitle, handler: {
                    guard let name = name else {
                        fatalError("name should never be nil")
                    }
                    completion(.success(name))
                }), Alert.Action(title: L10n.randomButtonTitle, handler: {
                    completion(.success(UUID().uuidString))
                })],
                textField: Alert.TextField(placeholder: L10n.newDocumentAlertPlaceholder, text: nil, handler: { text in
                    name = text
                    onMain {
                        if let text = text, !text.isEmpty && !list.contains(text) {
                            self.alertController.setIsButtonEnabled(true, at: 1)
                        } else {
                            self.alertController.setIsButtonEnabled(false, at: 1)
                        }
                    }
                })
            )
            onMain {
                self.alertController.showAlert(alert)
                self.alertController.setIsButtonEnabled(false, at: 1)
            }
        }
    }
}
