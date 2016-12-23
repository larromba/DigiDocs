//
//  PDF.swift
//  DigiDocs
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import UIKit

struct PDF {
    static let ext = "pdf"
    
    enum ErrorType: Error {
        case context
    }
    
    fileprivate let images: [UIImage]
    let path: URL

    init?(images: [UIImage], name: String) {
        guard images.count > 0 else {
            return nil
        }
        guard var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return nil
        }
        path.appendPathComponent("\(name).\(PDF.ext)")
        self.path = path
        self.images = images
    }
    
    // MARK: - Internal
    
    func generate(_ completion: @escaping ((_ error: Error?) -> Void)) {
        DispatchQueue.global().async(execute: {
            guard self.images.count > 0 else {
                fatalError("images count <= 0")
            }
            let bounds = CGRect(x: 0, y: 0, width: self.images[0].size.width, height: self.images[0].size.height)
            guard UIGraphicsBeginPDFContextToFile(self.path.relativePath, bounds, nil) else {
                DispatchQueue.main.async(execute: {
                    completion(ErrorType.context)
                })
                return
            }
            for image in self.images {
                UIGraphicsBeginPDFPageWithInfo(bounds, nil)
                image.draw(at: .zero)
            }
            UIGraphicsEndPDFContext()
            DispatchQueue.main.async(execute: {
                completion(nil)
            })
        })
    }
}
