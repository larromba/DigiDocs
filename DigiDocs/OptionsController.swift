import UIKit

// sourcery: name = OptionsController
protocol OptionsControlling: Mockable {
    func setDelegate(_ delegate: OptionsControllerDelegate)
    func displayOptions()
}

protocol OptionsControllerDelegate: AnyObject {
    func controller(_ controller: OptionsController, performAction action: OptionAction)
}

final class OptionsController: OptionsControlling {
    private let presenter: Presentable
    private weak var delegate: OptionsControllerDelegate?

    init(presenter: Presentable) {
        self.presenter = presenter
    }

    func setDelegate(_ delegate: OptionsControllerDelegate) {
        self.delegate = delegate
    }

    func displayOptions() {
        let options = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        options.addAction(UIAlertAction(title: L10n.viewAllOption, style: .default, handler: { _ in
            self.delegate?.controller(self, performAction: .viewAll)
        }))
        options.addAction(UIAlertAction(title: L10n.shareAllOption, style: .default, handler: { _ in
            self.delegate?.controller(self, performAction: .shareAll)
        }))
        options.addAction(UIAlertAction(title: L10n.deleteAllOption, style: .default, handler: { _ in
            self.delegate?.controller(self, performAction: .deleteAll)
        }))
        options.addAction(UIAlertAction(title: L10n.cancelButtonTitle, style: .cancel, handler: nil))
        presenter.present(options, animated: true, completion: nil)
    }
}
