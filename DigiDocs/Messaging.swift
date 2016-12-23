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
        let alert = UIAlertController(title: "Message".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: handler))
        present(alert, animated: true, completion: nil)
    }
    
    func showFatalError(handler: ((_ action: UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Error".localized, message: "Something went wrong - please try again. If the problem persists, please contact the developer".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: handler))
        present(alert, animated: true, completion: nil)
    }
}
