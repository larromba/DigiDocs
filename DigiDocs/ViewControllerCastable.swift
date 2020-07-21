import UIKit

protocol ViewControllerCastable {
    var casted: UIViewController { get }
}

extension ViewControllerCastable {
    var casted: UIViewController {
        guard let viewController = self as? UIViewController else {
            fatalError("expected UIViewController")
        }
        return viewController
    }
}
