//
//  PDFList.swift
//  DigiDocs
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import Foundation

struct PDFList {
    let paths: [URL]
    
    init?() {
        let fileManager = FileManager.default
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return nil
        }
        do {
            let documents = try fileManager.contentsOfDirectory(atPath: documentsPath.relativePath)
            let pdfDocuments = documents.filter({ $0.contains(".\(PDF.ext)") })
            guard pdfDocuments.count > 0 else {
                return nil
            }
            paths = pdfDocuments.map({ (name: String) -> URL in
                let path = documentsPath.appendingPathComponent(name)
                return path
            })
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    func delete() -> Error? {
        for url in paths {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                return error
            }
        }
        return nil
    }
    
    // MARK: - Internal
    
    static func contains(_ name: String) -> Bool {
        guard let list = PDFList() else {
            return false
        }
        let paths = list.paths.filter({ $0.lastPathComponent == "\(name).\(PDF.ext)" })
        let result = (paths.count > 0)
        return result
    }
}
