//
//  PDFViewControllerTests.swift
//  DigiDocsTests
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import XCTest
@testable import DigiDocs

class PDFViewControllerTests: XCTestCase {
    fileprivate var expectation: XCTestExpectation!
    fileprivate var viewController: PDFViewController!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        UIApplication.shared.keyWindow!.rootViewController = nil
        FileManager.clearAll(in: .documentDirectory)
        expectation = nil
        viewController = nil
        super.tearDown()
    }
    
    func testDeleteConfirmation() {
        let viewController = PDFViewController(paths: [])!
        UIApplication.shared.keyWindow!.rootViewController = viewController
        let button = viewController.navigationItem.rightBarButtonItem!
        
        UIApplication.shared.sendAction(button.action!, to: button.target!, from: nil, for: nil)
        XCTAssertTrue(viewController.presentedViewController is UIAlertController)
        XCTAssertEqual((viewController.presentedViewController as! UIAlertController).message, "Are you sure?".localized)
    }
    
    func testDeleteFile() {
        let url = FileManager.save(Data(), name: "\(#function).pdf", in: .documentDirectory)
        viewController = PDFViewController(paths: [url])
        UIApplication.shared.keyWindow!.rootViewController = viewController
        let button = viewController.navigationItem.rightBarButtonItem!
       
        UIApplication.shared.sendAction(button.action!, to: button.target!, from: nil, for: nil)
        let controller = viewController.presentedViewController as! UIAlertController
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.relativePath))
        controller.tapButton(atIndex: 1)
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.relativePath))
    }
}
