@testable import DigiDocs
import TestExtensions
import XCTest

final class CameraTests: XCTestCase {
    private var mainViewController: MainViewController!
    private var camera: Camera!
    private var cameraOverlay: CameraOverlayViewController!
    private var env: AppTestEnvironment!

    override func setUp() {
        super.setUp()
        mainViewController = UIStoryboard.main.instantiateInitialViewController() as? MainViewController
        cameraOverlay = UIStoryboard.camera.instantiateInitialViewController() as? CameraOverlayViewController
        camera = Camera(overlay: cameraOverlay, pickerType: SimulatorImagePickerController.self)
        env = AppTestEnvironment(mainViewController: mainViewController, camera: camera, cameraOverlay: cameraOverlay)
        env.setInWindow(mainViewController)
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        mainViewController = nil
        cameraOverlay = nil
        camera = nil
        env = nil
        UIView.setAnimationsEnabled(true)
        SimulatorImagePickerController.isSourceTypeAvailable = true
        super.tearDown()
    }

    func testCancelClosesCamera() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.cameraButton.fire())

        // precondition
        XCTAssertNotNil(mainViewController.presentedViewController)

        // sut
        XCTAssertTrue(cameraOverlay.cancelButton.fire())

        // test
        waitSync()
        XCTAssertNil(mainViewController.presentedViewController)
    }

    func testDoneOpensNameFileDialogue() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.cameraButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())

        // sut
        XCTAssertTrue(cameraOverlay.doneButton.fire())

        // test
        waitSync()
        guard let alertController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertEqual(alertController.title, "Document Name")
    }

    func testTakeButtonTakesPhotos() {
        // mocks
        class MockDelegate: CameraDelegate {
            var photos = [UIImage]()

            func camera(_ camera: Camera, didTakePhoto photo: UIImage) {
                photos.append(photo)
            }
            func cameraDidCancel(_ camera: Camera) {}
        }
        env.inject()
        let delegate = MockDelegate()
        camera.setDelegate(delegate)

        // sut
        XCTAssertTrue(cameraOverlay.takeButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())

        // test
        XCTAssertEqual(delegate.photos.count, 2)
    }

    func testDoneIsNotEnabledWith0Photos() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.cameraButton.fire())

        // test
        XCTAssertFalse(cameraOverlay.doneButton.isEnabled)
    }

    func testDoneIsEnabledWithPhotos() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.cameraButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())

        // test
        XCTAssertTrue(cameraOverlay.doneButton.isEnabled)
    }

    func testPhotoCount() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.cameraButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())

        // test
        XCTAssertEqual(cameraOverlay.numberLabel.text, "3 photos")
    }

    func testCameraNotAvailableOnPressingButtonDisplaysAlert() {
        // mocks
        env.inject()
        SimulatorImagePickerController.isSourceTypeAvailable = false

        // sut
        XCTAssertTrue(mainViewController.cameraButton.fire())

        // test
        waitSync()
        guard let alertController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertEqual(alertController.title, "Your camera is currently not available")
    }
}
