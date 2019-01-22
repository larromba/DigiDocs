import Foundation

protocol NamingControlling {
    func getName(_ completion: @escaping ((_ name: String?) -> Void))
}

final class NamingController: NamingControlling {
    private let alertController: AlertControlling
    private let pdfService: PDFServicing

    init(alertController: AlertControlling, pdfService: PDFServicing) {
        self.alertController = alertController
        self.pdfService = pdfService
    }

    func getName(_ completion: @escaping ((_ name: String?) -> Void)) {
        let list = pdfService.generateList()
        var name: String?
        let alert = Alert(
            title: L10n.newDocumentAlertTitle,
            message: L10n.newDocumentAlertMessage,
            cancel: Alert.Action(title: L10n.cancelButtonTitle, handler: nil),
            actions: [Alert.Action(title: L10n.okButtonTitle, handler: {
                completion(name)
            })],
            textField: Alert.TextField(placeholder: L10n.newDocumentAlertPlaceholder, text: nil, handler: { text in
                name = text
                if let text = text, !list.contains(text) {
                    self.alertController.setIsButtonEnabled(true, at: 1)
                } else {
                    self.alertController.setIsButtonEnabled(false, at: 1)
                }
            })
        )
        alertController.showAlert(alert)
    }
}
