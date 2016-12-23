//
//  FileManager+Utility.swift
//  DigiDocs
//
//  Created by Lee Arromba on 22/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import Foundation

extension FileManager {
    static func clearAll(in directory: SearchPathDirectory) {
        let url = FileManager.default.urls(for: directory, in: .userDomainMask).last!
        let contents = try! FileManager.default.contentsOfDirectory(atPath: url.relativePath)
        for name in contents {
            do {
                try FileManager.default.removeItem(at: self.url(forName: name, in: directory))
            } catch {
                debugPrint(error)
            }
        }
    }
    
    static func remove(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            debugPrint(error)
        }
    }
    
    static func save(_ data: Data, name: String, in directory: SearchPathDirectory) -> URL {
        let url = self.url(forName: name, in: directory)
        do {
            try data.write(to: url, options: [.atomic])
        } catch {
            debugPrint(error)
        }
        return url
    }
    
    static func url(forName name: String, in directory: SearchPathDirectory) -> URL {
        var url = FileManager.default.urls(for: directory, in: .userDomainMask).last!
        url.appendPathComponent(name)
        return url
    }
}
