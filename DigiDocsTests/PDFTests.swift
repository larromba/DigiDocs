//
//  PDFTests.swift
//  DigiDocsTests
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import XCTest
@testable import DigiDocs

class PDFTests: XCTestCase {
    fileprivate var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        FileManager.clearAll(in: .documentDirectory)
        expectation = nil
        super.tearDown()
    }
    
    func testPDFGenerates() {
        expectation = expectation(description: "pdf.generate(_:)")
        
        let pdf = PDF(images: [UIImage()], name: "\(#function)")!
        pdf.generate({ (error: Error?) in
            XCTAssertNil(error)
            XCTAssertTrue(FileManager.default.fileExists(atPath: pdf.path.relativePath))
            self.expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
}
