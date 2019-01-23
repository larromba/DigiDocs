import UIKit

struct Alert {
    struct Action {
        let title: String
        let handler: (() -> Void)?
    }
    final class TextField {
        let placeholder: String
        let text: String?
        let handler: (((String?) -> Void))?

        @objc
        func textChanged(_ textField: UITextField) {
            handler?(textField.text)
        }

        init(placeholder: String, text: String?, handler: (((String?) -> Void))?) {
            self.placeholder = placeholder
            self.text = text
            self.handler = handler
        }
    }

    let title: String
    let message: String
    let cancel: Action
    let actions: [Action]
    let textField: TextField?
}

extension Alert {
    init(error: Error) {
        title = L10n.errorAlertTitle
        message = error.localizedDescription
        cancel = Action(title: L10n.okButtonTitle, handler: nil)
        actions = []
        textField = nil
    }

    init(title: String, message: String = "") {
        self.title = title
        self.message = message
        cancel = Alert.Action(title: L10n.okButtonTitle, handler: nil)
        actions = []
        textField = nil
    }
}
