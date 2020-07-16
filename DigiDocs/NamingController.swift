import AsyncAwait
import Foundation

// sourcery: name = NamingController
protocol NamingControlling: Mockable {
    func getName() -> Async<String, Error>
}

final class NamingController: NamingControlling {
    private let alertController: AlertControlling
    private let pdfService: PDFServicing

    init(alertController: AlertControlling, pdfService: PDFServicing) {
        self.alertController = alertController
        self.pdfService = pdfService
    }

    func getName() -> Async<String, Error> {
        return Async { completion in
            let list = self.pdfService.generateList()
            var name: String?
            let confirm = Alert.Action(title: L10n.okButtonTitle, handler: {
                guard let name = name else {
                    assertionFailure("name should never be nil")
                    return
                }
                completion(.success(self.cleanName(name)))
            })
            let random = Alert.Action(title: L10n.randomButtonTitle, handler: {
                completion(.success(UUID().uuidString))
            })
            let textField = Alert.TextField(placeholder: L10n.newDocumentAlertPlaceholder, text: nil, handler: { text in
                name = text
                if let text = text, !text.isEmpty && !list.contains(text) {
                    onMain { self.alertController.setIsButtonEnabled(true, at: 1) }
                } else {
                    onMain { self.alertController.setIsButtonEnabled(false, at: 1) }
                }
            })
            let alert = Alert(
                title: L10n.newDocumentAlertTitle,
                message: L10n.newDocumentAlertMessage,
                cancel: Alert.Action(title: L10n.cancelButtonTitle, handler: nil),
                actions: [confirm, random],
                textField: textField
            )
            onMain {
                self.alertController.showAlert(alert)
                self.alertController.setIsButtonEnabled(false, at: 1)
            }
        }
    }

    // MARK: - private

    // swiftlint:disable joined_default_parameter
    private func cleanName(_ name: String) -> String {
        var invalidCharacters = CharacterSet(charactersIn: ":/.\\")
        invalidCharacters.formUnion(.newlines)
        invalidCharacters.formUnion(.illegalCharacters)
        invalidCharacters.formUnion(.controlCharacters)
        return name.components(separatedBy: invalidCharacters).joined(separator: "")
    }
}
