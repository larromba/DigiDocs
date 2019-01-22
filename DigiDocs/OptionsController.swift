import UIKit

protocol OptionsControlling {
    func setDelegate(_ delegate: OptionsControllerDelegate)
    func displayOptions()
}

protocol OptionsControllerDelegate: AnyObject {
    func controller(_ controller: OptionsController, performAction action: OptionAction)
}

final class OptionsController: OptionsControlling {
    private let presenter: Presentable
    private let alertController: AlertControlling
    private weak var delegate: OptionsControllerDelegate?

    init(presenter: Presentable, alertController: AlertControlling) {
        self.presenter = presenter
        self.alertController = alertController
    }

    func setDelegate(_ delegate: OptionsControllerDelegate) {
        self.delegate = delegate
    }

    func displayOptions() {
        let options = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // TODO: localize 
        options.addAction(UIAlertAction(title: "View all"/*L10n.viewAllOption*/, style: .default, handler: { _ in
            self.delegate?.controller(self, performAction: .viewAll)
        }))
        options.addAction(UIAlertAction(title: L10n.shareAllOption, style: .default, handler: { _ in
            self.delegate?.controller(self, performAction: .shareAll)
        }))
        options.addAction(UIAlertAction(title: L10n.deleteAllOption, style: .default, handler: { _ in
            self.displayConfirmation()
        }))
        options.addAction(UIAlertAction(title: L10n.cancelButtonTitle, style: .cancel, handler: nil))
        presenter.present(options, animated: true, completion: nil)
    }

    // MARK: - private

    private func displayConfirmation() {
        let alert = Alert(
            title: L10n.warningAlertTitle,
            message: L10n.areYouSureAlertTitle,
            cancel: Alert.Action(title: L10n.noButtonTitle, handler: nil),
            actions: [Alert.Action(title: L10n.yesButtonTitle, handler: {
                self.delegate?.controller(self, performAction: .deleteAll)
            })],
            textField: nil
        )
        alertController.showAlert(alert)
    }
}
