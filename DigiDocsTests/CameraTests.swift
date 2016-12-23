//
//  CameraTests.swift
//  DigiDocsTests
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import XCTest
@testable import DigiDocs

class CameraTests: XCTestCase {
    fileprivate var expectation: XCTestExpectation!
    fileprivate var camera: Camera!
    fileprivate var delegate: CameraDelegate!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        UIApplication.shared.keyWindow!.rootViewController = nil
        expectation = nil
        camera = nil
        delegate = nil
        super.tearDown()
    }
    
    func testOpen() {        
        class Delegate: CameraDelegate {
            func cameraDidCancel(_ camera: Camera) {}
            func cameraDidFinish(_ camera: Camera) {}
            func camera(_ camera: Camera, didTakePhoto photo: UIImage) {}
        }
        let picker = UIImagePickerController()
        let overlay = UIStoryboard.camera.instantiateInitialViewController() as! CameraOverlayViewController
        let presenter = UIViewController()
        UIApplication.shared.keyWindow!.rootViewController = presenter
        camera = Camera(type: SimulatorImagePickerController.self, picker: picker, overlay: overlay)
      
        camera.open(in: presenter, delegate: Delegate())
        XCTAssertTrue(presenter.presentedViewController is UIImagePickerController)
    }
    
    func testIsDoneEnabledTrue() {
        let overlay = UIStoryboard.camera.instantiateInitialViewController() as! CameraOverlayViewController
        overlay.preloadView()
        let picker = UIImagePickerController()
        camera = Camera(picker: picker, overlay: overlay)
        
        camera.isDoneEnabled = true
        XCTAssertTrue(overlay.doneButton.isEnabled)
        XCTAssertEqualWithAccuracy(1.0, overlay.doneButton.alpha, accuracy: 0.1)
    }
    
    func testIsDoneEnabledFalse() {
        let overlay = UIStoryboard.camera.instantiateInitialViewController() as! CameraOverlayViewController
        overlay.preloadView()
        let picker = UIImagePickerController()
        camera = Camera(picker: picker, overlay: overlay)
      
        camera.isDoneEnabled = false
        XCTAssertFalse(overlay.doneButton.isEnabled)
        XCTAssertEqualWithAccuracy(0.3, overlay.doneButton.alpha, accuracy: 0.1)
    }
    
    func testTakePicture() {
        expectation = expectation(description: "picker.takePicture()")
        
        class MockPicker: UIImagePickerController {
            fileprivate var expectation: XCTestExpectation!
            override func takePicture() {
                expectation.fulfill()
            }
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init(nibName: nil, bundle: nil)
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        let picker = MockPicker(expectation: expectation)
        let overlay = CameraOverlayViewController()
        camera = Camera(picker: picker, overlay: overlay)
    
        camera.cameraOverlayTakePressed(overlay)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testTakePictureDelegate() {
        expectation = expectation(description: "delegate.camera(_:, didTakePhoto(_:))")
        
        class Delegate: CameraDelegate {
            fileprivate var expectation: XCTestExpectation!
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            func cameraDidCancel(_ camera: Camera) {}
            func cameraDidFinish(_ camera: Camera) {}
            func camera(_ camera: Camera, didTakePhoto photo: UIImage) {
                expectation.fulfill()
            }
        }
        let picker = UIImagePickerController(nibName: nil, bundle: nil)
        let overlay = UIStoryboard.camera.instantiateInitialViewController() as! CameraOverlayViewController
        overlay.preloadView()
        camera = Camera(picker: picker, overlay: overlay)
        delegate = Delegate(expectation: expectation)
        camera.delegate = delegate
      
        camera.imagePickerController(picker, didFinishPickingMediaWithInfo: [UIImagePickerControllerOriginalImage: UIImage()])
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testPickerCancel() {
        expectation = expectation(description: "delegate.cameraDidCancel(_:)")
        
        class MockPicker: UIImagePickerController {
            fileprivate var expectation: XCTestExpectation!
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                completion?()
            }
            init() {
                super.init(nibName: nil, bundle: nil)
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        class Delegate: CameraDelegate {
            fileprivate var expectation: XCTestExpectation!
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            func cameraDidCancel(_ camera: Camera) {
                expectation.fulfill()
            }
            func cameraDidFinish(_ camera: Camera) {}
            func camera(_ camera: Camera, didTakePhoto photo: UIImage) {}
        }
        let picker = MockPicker()
        let overlay = CameraOverlayViewController()
        camera = Camera(picker: picker, overlay: overlay)
        delegate = Delegate(expectation: expectation)
        camera.delegate = delegate
      
        camera.imagePickerControllerDidCancel(picker)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testDoneDismissesPicker() {
        expectation = expectation(description: "picker.dismiss(_:, _:)")
        
        class MockPicker: UIImagePickerController {
            fileprivate var expectation: XCTestExpectation!
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                expectation.fulfill()
            }
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init(nibName: nil, bundle: nil)
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        let picker = MockPicker(expectation: expectation)
        let overlay = CameraOverlayViewController()
        camera = Camera(picker: picker, overlay: overlay)
      
        camera.cameraOverlayDonePressed(overlay)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testFinishDelegate() {
        expectation = expectation(description: "delegate.cameraDidFinish(_:)")
        
        class MockPicker: UIImagePickerController {
            fileprivate var expectation: XCTestExpectation!
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                completion?()
            }
            init() {
                super.init(nibName: nil, bundle: nil)
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        class Delegate: CameraDelegate {
            fileprivate var expectation: XCTestExpectation!
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            func cameraDidCancel(_ camera: Camera) {}
            func cameraDidFinish(_ camera: Camera) {
                expectation.fulfill()
            }
            func camera(_ camera: Camera, didTakePhoto photo: UIImage) {}
        }
        
        let picker = MockPicker()
        let overlay = CameraOverlayViewController()
        camera = Camera(picker: picker, overlay: overlay)
        delegate = Delegate(expectation: expectation)
        camera.delegate = delegate
     
        camera.cameraOverlayDonePressed(overlay)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testCancelDismissesPicker() {
        expectation = expectation(description: "picker.dismiss(_:, _:)")
        
        class MockPicker: UIImagePickerController {
            fileprivate var expectation: XCTestExpectation!
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                expectation.fulfill()
            }
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init(nibName: nil, bundle: nil)
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        let picker = MockPicker(expectation: expectation)
        let overlay = CameraOverlayViewController()
        camera = Camera(picker: picker, overlay: overlay)
     
        camera.cameraOverlayCancelPressed(overlay)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testCancelDelegate() {
        expectation = expectation(description: "delegate.cameraDidCancel(_:)")
        
        class MockPicker: UIImagePickerController {
            fileprivate var expectation: XCTestExpectation!
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                completion?()
            }
            init() {
                super.init(nibName: nil, bundle: nil)
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        class Delegate: CameraDelegate {
            fileprivate var expectation: XCTestExpectation!
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            func cameraDidCancel(_ camera: Camera) {
                expectation.fulfill()
            }
            func cameraDidFinish(_ camera: Camera) {}
            func camera(_ camera: Camera, didTakePhoto photo: UIImage) {}
        }
        
        let picker = MockPicker()
        let overlay = CameraOverlayViewController()
        camera = Camera(picker: picker, overlay: overlay)
        delegate = Delegate(expectation: expectation)
        camera.delegate = delegate
     
        camera.cameraOverlayCancelPressed(overlay)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
}
