//
//  Messaging.swift
//  DigiDocs
//
//  Created by Lee Arromba on 22/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import UIKit

protocol Messaging {
    func showMessage(_ message: String, handler: ((_ action: UIAlertAction) -> Void)?)
    func showFatalError(handler: ((_ action: UIAlertAction) -> Void)?)
}

extension Messaging where Self: UIViewController {
    func showMessage(_ message: String, handler: ((_ action: UIAlertAction) -> Void)? = nil) {
        Analytics.shared.sendEvent("message_show", classId: classForCoder)
        let alert = UIAlertController(title: "Message".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: handler))
        present(alert, animated: true, completion: nil)
    }
    
    func showError(_ error: Error, handler: ((_ action: UIAlertAction) -> Void)? = nil) {
        Analytics.shared.sendEvent("error_show", classId: classForCoder)
        let alert = UIAlertController(title: "Error".localized, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: handler))
        present(alert, animated: true, completion: nil)
    }
    
    func showFatalError(handler: ((_ action: UIAlertAction) -> Void)? = nil) {
        Analytics.shared.sendEvent("fatal_error_show", classId: classForCoder)
        let alert = UIAlertController(title: "Error".localized, message: "Something went wrong - please try again. If the problem persists, please contact the developer".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: handler))
        present(alert, animated: true, completion: nil)
    }
    
    func getConfirmation(_ handler: @escaping ((Void) -> Void)) {
        Analytics.shared.sendEvent("delete_confirmation_show", classId: classForCoder)
        let alert = UIAlertController(title: "Warning".localized, message: "Are you sure?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No".localized, style: .default, handler: { (_) in
            Analytics.shared.sendButtonPressEvent("no", classId: self.classForCoder)
        }))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (_) in
            Analytics.shared.sendButtonPressEvent("yes", classId: self.classForCoder)
            handler()
        }))
        present(alert, animated: true, completion: nil)
    }
}
