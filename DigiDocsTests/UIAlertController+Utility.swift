//
//  UIAlertController+Utility.swift
//  DigiDocs
//
//  Created by Lee Arromba on 22/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import UIKit

extension UIAlertController {
    typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
    
    func tapButton(atIndex index: Int) {
        if let block = actions[index].value(forKey: "handler") {
            let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
            let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
            handler(actions[index])
        }
    }
}
