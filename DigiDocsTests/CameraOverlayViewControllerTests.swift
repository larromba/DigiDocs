//
//  CameraOverlayViewControllerTests.swift
//  DigiDocsTests
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import XCTest
@testable import DigiDocs

class CameraOverlayViewControllerTests: XCTestCase {
    fileprivate var expectation: XCTestExpectation!
    fileprivate var viewController: CameraOverlayViewController!
    fileprivate var delegate: CameraOverlayViewControllerDelegate!

    override func setUp() {
        viewController = UIStoryboard.camera.instantiateInitialViewController() as! CameraOverlayViewController
        viewController.preloadView()
        super.setUp()
    }
    
    override func tearDown() {
        expectation = nil
        viewController = nil
        delegate = nil
        super.tearDown()
    }
    
    func testTakeButton() {
        expectation = expectation(description: "delegate.cameraOverlayTakePressed()")
        class Delegate: CameraOverlayViewControllerDelegate {
            fileprivate var expectation: XCTestExpectation!
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            func cameraOverlayTakePressed(_ cameraOverlay: CameraOverlayViewController) {
                expectation.fulfill()
            }
            func cameraOverlayDonePressed(_ cameraOverlay: CameraOverlayViewController) {}
            func cameraOverlayCancelPressed(_ cameraOverlay: CameraOverlayViewController) {}
        }
        let delegate = Delegate(expectation: expectation)
        viewController.delegate = delegate
        
        viewController.takeButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testDoneButton() {
        expectation = expectation(description: "delegate.cameraOverlayTakePressed()")
        class Delegate: CameraOverlayViewControllerDelegate {
            fileprivate var expectation: XCTestExpectation!
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            func cameraOverlayTakePressed(_ cameraOverlay: CameraOverlayViewController) {}
            func cameraOverlayDonePressed(_ cameraOverlay: CameraOverlayViewController) {
                expectation.fulfill()
            }
            func cameraOverlayCancelPressed(_ cameraOverlay: CameraOverlayViewController) {}
        }
        let delegate = Delegate(expectation: expectation)
        viewController.delegate = delegate
       
        viewController.doneButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testCancelButton() {
        expectation = expectation(description: "delegate.cameraOverlayTakePressed()")
        class Delegate: CameraOverlayViewControllerDelegate {
            fileprivate var expectation: XCTestExpectation!
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            func cameraOverlayTakePressed(_ cameraOverlay: CameraOverlayViewController) {}
            func cameraOverlayDonePressed(_ cameraOverlay: CameraOverlayViewController) {}
            func cameraOverlayCancelPressed(_ cameraOverlay: CameraOverlayViewController) {
                expectation.fulfill()
            }
        }
        let delegate = Delegate(expectation: expectation)
        viewController.delegate = delegate
      
        viewController.cancelButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
}
