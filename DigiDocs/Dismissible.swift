import UIKit

protocol Dismissible {
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}
extension UIViewController: Dismissible {}
