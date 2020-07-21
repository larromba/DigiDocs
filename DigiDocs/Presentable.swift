import UIKit

protocol Presentable: AnyObject {
    // sourcery: value = false
    var isPresenting: Bool { get }

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
extension UIViewController: Presentable {
    var isPresenting: Bool {
        return presentedViewController != nil
    }
}
