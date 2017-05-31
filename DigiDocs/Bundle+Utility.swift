//
//  Bundle+Utility.swift
//  DigiDocs
//
//  Created by Lee Arromba on 31/05/2017.
//  Copyright © 2017 Pink Chicken Ltd. All rights reserved.
//

import Foundation

extension Bundle {
    class var appVersion: String {
        return "v\(main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?")"
    }
}
