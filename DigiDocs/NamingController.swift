import AsyncAwait
import Foundation

// sourcery: name = NamingController
protocol NamingControlling: Mockable {
    func getName()
    func setDelegate(_ delegate: NamingControllerDelegate)
}

// sourcery: name = NamingControllerDelegate
protocol NamingControllerDelegate: AnyObject, Mockable {
    func controller(_ controller: NamingControlling, gotName name: String)
    func controller(_ controller: NamingControlling, showAlert alert: Alert)
    func controller(_ controller: NamingControlling, setIsAlertButtonEnabled isEnabled: Bool, at index: Int)
}

final class NamingController: NamingControlling {
    private let pdfService: PDFServicing
    private weak var delegate: NamingControllerDelegate?

    init(pdfService: PDFServicing) {
        self.pdfService = pdfService
    }

    func setDelegate(_ delegate: NamingControllerDelegate) {
        self.delegate = delegate
    }

    func getName() {
        async({
            let list = self.pdfService.generateList()
            var name: String?
            let confirm = Alert.Action(title: L10n.okButtonTitle, handler: {
                guard let name = name else {
                    assertionFailure("name should never be nil")
                    return
                }
                onMain { self.delegate?.controller(self, gotName: self.cleanName(name)) }
            })
            let random = Alert.Action(title: L10n.randomButtonTitle, handler: {
                onMain { self.delegate?.controller(self, gotName: self.randomName()) }
            })
            let textField = Alert.TextField(placeholder: L10n.newDocumentAlertPlaceholder, text: nil, handler: { text in
                name = text
                if let text = text, !text.isEmpty && !list.contains(text) {
                    onMain { self.delegate?.controller(self, setIsAlertButtonEnabled: true, at: 1) }
                } else {
                    onMain { self.delegate?.controller(self, setIsAlertButtonEnabled: false, at: 1) }
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
                self.delegate?.controller(self, showAlert: alert)
                self.delegate?.controller(self, setIsAlertButtonEnabled: false, at: 1)
            }
        }, onError: { error in
            onMain { self.delegate?.controller(self, showAlert: Alert(error: error)) }
        })
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

    private func randomName() -> String {
        return UUID().uuidString
    }
}
