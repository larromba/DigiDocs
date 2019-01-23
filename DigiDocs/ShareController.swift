import Logging
import UIKit

// sourcery: name = ShareController
protocol ShareControlling: Mockable {
    func shareItems(_ items: [URL])
}

final class ShareController: ShareControlling {
    private let presenter: Presentable
    private weak var current: UIActivityViewController?

    init(presenter: Presentable) {
        self.presenter = presenter
    }

    func shareItems(_ items: [URL]) {
        guard current == nil else {
            logWarning("already displaying UIActivityViewController")
            return
        }
        let viewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        presenter.present(viewController, animated: true, completion: nil)
        current = viewController
    }
}
