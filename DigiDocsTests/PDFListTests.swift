//
//  PDFListTests.swift
//  DigiDocsTests
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import XCTest
@testable import DigiDocs

class PDFListTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        FileManager.clearAll(in: .documentDirectory)

        super.tearDown()
    }
    
    func testListWithNoContents() {
        let list = PDFList()
        XCTAssertNil(list)
    }
    
    func testListWithContents() {
        _ = FileManager.save(Data(), name: "\(#function).pdf", in: .documentDirectory)
        let list = PDFList()
        XCTAssertEqual(list?.paths.count ?? 0, 1)
    }
}
