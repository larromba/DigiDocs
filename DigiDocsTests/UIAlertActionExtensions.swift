import UIKit

private typealias Handler = @convention(block) (UIAlertAction) -> Void

extension UIAlertAction {
    @discardableResult
    func fire() -> Bool {
        guard let block = value(forKey: "handler") else { return false }
        let handler = unsafeBitCast(block as AnyObject, to: Handler.self)
        handler(self)
        return true
    }
}
