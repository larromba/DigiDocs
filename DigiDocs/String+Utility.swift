//
//  String+Utility.swift
//  DigiDocs
//
//  Created by Lee Arromba on 22/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "\(#file)")
    }
}
