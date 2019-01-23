import UIKit

protocol ViewControllerCastable {
    var asViewController: UIViewController { get }
}

extension ViewControllerCastable {
    var asViewController: UIViewController {
        guard let viewController = self as? UIViewController else {
            fatalError("expected UIViewController")
        }
        return viewController
    }
}
