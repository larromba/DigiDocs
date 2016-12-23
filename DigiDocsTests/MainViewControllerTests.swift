//
//  MainViewControllerTests.swift
//  DigiDocs
//
//  Created by Lee Arromba on 22/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import DigiDocs

class MainViewControllerTests: XCTestCase {
    fileprivate var expectation: XCTestExpectation!
    fileprivate var viewController: MainViewController!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        FileManager.clearAll(in: .documentDirectory)
        viewController = nil
        expectation = nil
        super.tearDown()
    }
    
    func testIsLoadingTrue() {
        let activityIndicator = UIActivityIndicatorView()
        let cameraButton = UIButton()
        let listButton = UIButton()
        viewController = MainViewController(photos: [], camera: Camera(), cameraButton: cameraButton, listButton: listButton, activityIndicator: activityIndicator, isLoading: true)
        XCTAssertTrue(activityIndicator.isAnimating)
        XCTAssertFalse(cameraButton.isEnabled)
        XCTAssertFalse(listButton.isEnabled)
    }
    
    func testIsLoadingFalse() {
        let activityIndicator = UIActivityIndicatorView()
        let cameraButton = UIButton()
        let listButton = UIButton()
        viewController = MainViewController(photos: [], camera: Camera(), cameraButton: cameraButton, listButton: listButton, activityIndicator: activityIndicator, isLoading: false)
        XCTAssertFalse(activityIndicator.isAnimating)
        XCTAssertTrue(cameraButton.isEnabled)
        XCTAssertTrue(listButton.isEnabled)
    }
    
    func testIsUiEnabledTrue() {
        let cameraButton = UIButton()
        let listButton = UIButton()
        viewController = MainViewController(photos: [], camera: Camera(), cameraButton: cameraButton, listButton: listButton, activityIndicator: UIActivityIndicatorView(), isUiEnabled: true)
        XCTAssertTrue(cameraButton.isEnabled)
        XCTAssertTrue(listButton.isEnabled)
    }
    
    func testIsUiEnabledFalse() {
        let cameraButton = UIButton()
        let listButton = UIButton()
        viewController = MainViewController(photos: [], camera: Camera(), cameraButton: cameraButton, listButton: listButton, activityIndicator: UIActivityIndicatorView(), isUiEnabled: false)
        XCTAssertFalse(cameraButton.isEnabled)
        XCTAssertFalse(listButton.isEnabled)
    }
    
    func testCameraNotAvailable() {
        class MockCamera: Camera {
            override var isAvailable: Bool {
                return false
            }
        }
        let cameraButton = UIButton()
        viewController = MainViewController(photos: [], camera: MockCamera(), cameraButton: cameraButton, listButton: UIButton(), activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController

        cameraButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewController.presentedViewController! is UIAlertController)
        XCTAssertEqual((viewController.presentedViewController as! UIAlertController).message, "Your camera is currently not available".localized)
    }
    
    func testCameraOpens() {
        class MockCamera: Camera {
            override var isAvailable: Bool {
                return true
            }
        }
        let cameraButton = UIButton()
        let overlay = UIStoryboard.camera.instantiateInitialViewController() as! CameraOverlayViewController
        let camera = MockCamera(type: SimulatorImagePickerController.self, picker: UIImagePickerController(), overlay: overlay)
        viewController = MainViewController(photos: [], camera: camera, cameraButton: cameraButton, listButton: UIButton(), activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        cameraButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewController.presentedViewController! is UIImagePickerController)
    }
    
    func testCameraOpenedUiState() {
        expectation = expectation(description: "camera.isDoneEnabled")
        
        class MockCamera: Camera {
            let expectation: XCTestExpectation!
            override var isDoneEnabled: Bool {
                get { return super.isDoneEnabled }
                set {
                    if !newValue {
                        expectation.fulfill()
                    }
                }
            }
            override var isAvailable: Bool {
                return true
            }
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func open(in viewController: UIViewController, delegate: CameraDelegate, completion: ((Void) -> Void)?) {
                completion?()
            }
        }
        let cameraButton = UIButton()
        viewController = MainViewController(photos: [], camera: MockCamera(expectation: expectation), cameraButton: cameraButton, listButton: UIButton(), activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        cameraButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testListPressedNoDocs() {
        let listButton = UIButton()
        viewController = MainViewController(photos: [], camera: Camera(), cameraButton: UIButton(), listButton: listButton, activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        listButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewController.presentedViewController! is UIAlertController)
        XCTAssertEqual((viewController.presentedViewController as! UIAlertController).message, "You have no documents saved".localized)
    }
    
    func testListOpened() {
        expectation = expectation(description: "mainViewController.present(_:, _:, _:)")
        
        class MockMainViewController: MainViewController {
            let expectation: XCTestExpectation!
            override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
                if viewControllerToPresent is PDFViewController {
                    expectation.fulfill()
                }
            }
            init(expectation: XCTestExpectation, photos: [UIImage], camera: Camera, cameraButton: UIButton, listButton: UIButton, activityIndicator: UIActivityIndicatorView, isLoading: Bool? = nil, isUiEnabled: Bool? = nil) {
                self.expectation = expectation
                super.init(photos: photos, camera: camera, cameraButton: cameraButton, listButton: listButton, activityIndicator: activityIndicator, isLoading: isLoading, isUiEnabled: isUiEnabled)
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        _ = FileManager.save(Data(), name: "\(#function).pdf", in: .documentDirectory)
        let listButton = UIButton()
        viewController = MockMainViewController(expectation: expectation, photos: [], camera: Camera(), cameraButton: UIButton(), listButton: listButton, activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        listButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: 1.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }

    func testListOpenedStartLoading() {
        _ = FileManager.save(Data(), name: "\(#function).pdf", in: .documentDirectory)
        let listButton = UIButton()
        let activitityIndicator = UIActivityIndicatorView()
        viewController = MainViewController(photos: [], camera: Camera(), cameraButton: UIButton(), listButton: listButton, activityIndicator: activitityIndicator)
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        listButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(activitityIndicator.isAnimating)
    }
    
    func testListOpenedStopLoading() {
        class MockMainViewController: MainViewController {
            override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
                completion?()
            }
        }
        _ = FileManager.save(Data(), name: "\(#function).pdf", in: .documentDirectory)
        let listButton = UIButton()
        let activitityIndicator = UIActivityIndicatorView()
        viewController = MockMainViewController(photos: [], camera: Camera(), cameraButton: UIButton(), listButton: listButton, activityIndicator: activitityIndicator)
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        listButton.sendActions(for: .touchUpInside)
        XCTAssertFalse(activitityIndicator.isAnimating)
    }
    
    func testListOpenError() {
        _ = FileManager.save(Data(), name: "test.notapdf", in: .documentDirectory)
        let listButton = UIButton()
        viewController = MainViewController(photos: [], camera: Camera(), cameraButton: UIButton(), listButton: listButton, activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        listButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewController.presentedViewController! is UIAlertController)
        XCTAssertEqual((viewController.presentedViewController as! UIAlertController).message, "You have no documents saved".localized)
    }
    
    func testCameraCancelPhotosReset() {
        let photos = [UIImage(), UIImage()]
        let camera = Camera()
        viewController = MainViewController(photos: photos, camera: camera, cameraButton: UIButton(), listButton: UIButton(), activityIndicator: UIActivityIndicatorView())
        
        viewController.cameraDidCancel(camera)
        XCTAssertEqual(viewController.photos.count, 0)
    }
    
    func testCameraFinishedGetName() {
        let camera = Camera()
        viewController = MainViewController(photos: [], camera: camera, cameraButton: UIButton(), listButton: UIButton(), activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        viewController.cameraDidFinish(camera)
        XCTAssertTrue(viewController.presentedViewController! is UIAlertController)
        XCTAssertEqual((viewController.presentedViewController as! UIAlertController).message, "What name would you like to give the document?".localized)
        XCTAssertEqual((viewController.presentedViewController as! UIAlertController).textFields!.count, 1)
    }
    
    func testCameraFinishedGetNameNotLongEnough() {
        expectation = expectation(description: "wait")
        
        let camera = Camera()
        viewController = MainViewController(photos: [], camera: camera, cameraButton: UIButton(), listButton: UIButton(), activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        viewController.cameraDidFinish(camera)
        
        let alertController = viewController.presentedViewController as! UIAlertController
        let textField = alertController.textFields!.first!
        textField.text = ""

        alertController.dismiss(animated: false, completion: {
            alertController.tapButton(atIndex: 1)
            XCTAssertTrue(self.viewController.presentedViewController! is UIAlertController)
            XCTAssertEqual((self.viewController.presentedViewController as! UIAlertController).message, "You must enter a longer name".localized)
            self.expectation.fulfill()
        })
        waitForExpectations(timeout: 5.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testCameraFinishedGetNameExists() {
        expectation = expectation(description: "wait")
        
        _ = FileManager.save(Data(), name: "\(#function).pdf", in: .documentDirectory)
        let camera = Camera()
        viewController = MainViewController(photos: [], camera: camera, cameraButton: UIButton(), listButton: UIButton(), activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        viewController.cameraDidFinish(camera)
        
        let alertController = viewController.presentedViewController as! UIAlertController
        let textField = alertController.textFields!.first!
        textField.text = "\(#function)"
        
        alertController.dismiss(animated: false, completion: {
            alertController.tapButton(atIndex: 1)
            XCTAssertTrue(self.viewController.presentedViewController! is UIAlertController)
            XCTAssertEqual((self.viewController.presentedViewController as! UIAlertController).message, "A document with that name already exists, please try again".localized)
            self.expectation.fulfill()
        })
        waitForExpectations(timeout: 2.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testCameraFinishedGetNameMakePDFError() {
        expectation = expectation(description: "wait")
        
        let camera = Camera()
        viewController = MainViewController(photos: [], camera: camera, cameraButton: UIButton(), listButton: UIButton(), activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        viewController.cameraDidFinish(camera)
        
        let alertController = viewController.presentedViewController as! UIAlertController
        let textField = alertController.textFields!.first!
        textField.text = "test"
        
        alertController.dismiss(animated: false, completion: {
            alertController.tapButton(atIndex: 1)
            XCTAssertTrue(self.viewController.presentedViewController! is UIAlertController)
            XCTAssertEqual((self.viewController.presentedViewController as! UIAlertController).message, "Something went wrong - please try again. If the problem persists, please contact the developer".localized)
            self.expectation.fulfill()
        })
        waitForExpectations(timeout: 2.0, handler: { (error: Error?) in XCTAssertNil(error) })
    }
    
    func testCameraFinishedGetNameMakePDF() {
        let camera = Camera()
        viewController = MainViewController(photos: [UIImage()], camera: camera, cameraButton: UIButton(), listButton: UIButton(), activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        viewController.cameraDidFinish(camera)
        
        let alertController = viewController.presentedViewController as! UIAlertController
        let textField = alertController.textFields!.first!
        textField.text = "\(#function)"
        
        alertController.tapButton(atIndex: 1)
        sleep(2)
        XCTAssertTrue(FileManager.default.fileExists(atPath: FileManager.url(forName: "\(#function).pdf", in: .documentDirectory).relativePath))
    }
    
    func testCameraFinishedResetPhotos() {
        let camera = Camera()
        viewController = MainViewController(photos: [], camera: camera, cameraButton: UIButton(), listButton: UIButton(), activityIndicator: UIActivityIndicatorView())
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        viewController.cameraDidFinish(camera)
        
        let alertController = viewController.presentedViewController as! UIAlertController
        let textField = alertController.textFields!.first!
        textField.text = "\(#function)"
        
        alertController.tapButton(atIndex: 1)
        XCTAssertEqual(viewController.photos.count, 0)
    }
}
