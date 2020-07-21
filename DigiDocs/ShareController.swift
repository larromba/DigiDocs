import Logging
import UIKit

// sourcery: name = ShareController
protocol ShareControlling: Mockable {
    func shareItems(_ items: [URL])
}

final class ShareController: ShareControlling {
    private let presenter: Presentable

    init(presenter: Presentable) {
        self.presenter = presenter
    }

    func shareItems(_ items: [URL]) {
        guard !presenter.isPresenting else {
            logWarning("already presenting so won't show UIActivityViewController")
            return
        }
        let viewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        presenter.present(viewController, animated: true, completion: nil)
    }
}
