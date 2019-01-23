import UIKit

extension UIAlertController {
    @discardableResult
    func tapButton(at index: Int) -> Bool {
        dismiss(animated: false, completion: nil)
        return actions[safe: index]?.fire() ?? false
    }
}
