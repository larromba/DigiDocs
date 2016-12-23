//
//  PDFPreviewItemTests.swift
//  DigiDocsTests
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import XCTest
@testable import DigiDocs

class PDFPreviewItemTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        let url = URL(fileURLWithPath: "/var/test.pdf")
        let item = PDFPreviewItem(path: url)
        XCTAssertEqual(url, item.previewItemURL)
        XCTAssertEqual("test.pdf", item.previewItemTitle)
    }
}
