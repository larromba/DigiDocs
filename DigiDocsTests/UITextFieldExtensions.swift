import UIKit

extension UITextField {
    func setText(_ text: String) {
        self.text = text
        self.sendActions(for: .editingChanged)
    }
}
