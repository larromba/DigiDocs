import UIKit

extension UIAlertController {
    @discardableResult
    func tapButton(at index: Int) -> Bool {
        guard let action = actions[safe: index] else { return false }
        self.dismiss(animated: false) { action.fire() }
        return true
    }
}
