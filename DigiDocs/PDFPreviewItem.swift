//
//  PDFPreviewItem.swift
//  DigiDocs
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import QuickLook

class PDFPreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
    var previewItemTitle: String? {
        return previewItemURL?.lastPathComponent
    }
    
    init(path: URL) {
        self.previewItemURL = path
        super.init()
    }
}
