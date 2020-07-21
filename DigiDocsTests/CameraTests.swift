@testable import DigiDocs
import TestExtensions
import XCTest

final class CameraTests: XCTestCase {
    private var homeViewController: HomeViewController!
    private var camera: Camera!
    private var cameraOverlay: CameraOverlayViewController!
    private var env: AppTestEnvironment!

    override func setUp() {
        super.setUp()
        homeViewController = UIStoryboard.main.instantiateInitialViewController() as? HomeViewController
        cameraOverlay = UIStoryboard.camera.instantiateInitialViewController() as? CameraOverlayViewController
        camera = Camera(overlay: cameraOverlay, pickerType: SimulatorImagePickerController.self)
        env = AppTestEnvironment(homeViewController: homeViewController, camera: camera, cameraOverlay: cameraOverlay)
        env.setInWindow(homeViewController)
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        homeViewController = nil
        cameraOverlay = nil
        camera = nil
        env = nil
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    // MARK: - close button

    func test_closeButton_whenPressed_expectCameraCloses() {
        // mocks
        env.inject()
        XCTAssertTrue(homeViewController.cameraButton.fire())

        // precondition
        XCTAssertNotNil(homeViewController.presentedViewController)

        // sut
        XCTAssertTrue(cameraOverlay.cancelButton.fire())

        // test
        waitSync()
        XCTAssertNil(homeViewController.presentedViewController)
    }

    // MARK: - done button

    func test_doneButton_whenPressed_expectOpensNameFileDialogue() {
        // mocks
        env.inject()
        XCTAssertTrue(homeViewController.cameraButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())

        // sut
        XCTAssertTrue(cameraOverlay.doneButton.fire())

        // test
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertEqual(alertController.title, "Document Name")
    }

    func test_doneButton_whenZeroPhotosTaken_expectDisabled() {
        // mocks
        env.inject()
        XCTAssertTrue(homeViewController.cameraButton.fire())

        // test
        XCTAssertFalse(cameraOverlay.doneButton.isEnabled)
    }

    func test_doneButton_whenPhotosTaken_expectEnabled() {
        // mocks
        env.inject()
        XCTAssertTrue(homeViewController.cameraButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())

        // test
        XCTAssertTrue(cameraOverlay.doneButton.isEnabled)
    }

    // MARK: - take button

    func test_takeButton_whenPressed_expectTakesPhoto() {
        // mocks
        env.inject()
        let delegate = MockCameraDelegate()
        camera.setDelegate(delegate)

        // sut
        XCTAssertTrue(cameraOverlay.takeButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())

        // test
        XCTAssertEqual(delegate.invocations.count(MockCameraDelegate.camera1.name), 2)
    }

    func test_takeButton_whenPhotosTaken_expectNumberShown() {
        // mocks
        env.inject()
        XCTAssertTrue(homeViewController.cameraButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())

        // test
        XCTAssertEqual(cameraOverlay.numberLabel.text, "3 photos")
    }

    // MARK: - camera button

    func test_cameraButton_whenCameraNotAvailable_expectAlertShown() {
        // mocks
        env.inject()
        SimulatorImagePickerController.isSourceTypeAvailable = false

        // sut
        XCTAssertTrue(homeViewController.cameraButton.fire())

        // test
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertEqual(alertController.title, "Your camera is currently not available")
    }
}
