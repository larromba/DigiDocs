//
//  MessagingTests.swift
//  DigiDocsTests
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import XCTest
@testable import DigiDocs

class MessagingTests: XCTestCase {
    fileprivate class MockViewController: UIViewController, Messaging {}
    fileprivate var controller: MockViewController!
    
    override func setUp() {
        super.setUp()
        controller = MockViewController()
        UIApplication.shared.keyWindow!.rootViewController = controller
    }
    override func tearDown() {
        UIApplication.shared.keyWindow!.rootViewController = nil
        controller = nil
        super.tearDown()
    }
    
    func testShowMessage() {
        controller.showMessage("test")
        XCTAssertTrue(controller.presentedViewController is UIAlertController)
        XCTAssertEqual((controller.presentedViewController as! UIAlertController).message, "test")
    }
    
    func testShowFatalError() {
        controller.showFatalError()
        XCTAssertTrue(controller.presentedViewController is UIAlertController)
        XCTAssertEqual((controller.presentedViewController as! UIAlertController).message, "Something went wrong - please try again. If the problem persists, please contact the developer".localized)
    }
}
