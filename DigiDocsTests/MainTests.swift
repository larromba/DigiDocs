@testable import DigiDocs
import TestExtensions
import XCTest

final class MainTests: XCTestCase {
    private var mainViewController: MainViewController!
    private var camera: Camera!
    private var cameraOverlay: CameraOverlayViewController!
    private var env: AppTestEnvironment!
    private var pdfService: PDFService!

    override func setUp() {
        super.setUp()
        mainViewController = UIStoryboard.main.instantiateInitialViewController() as? MainViewController
        cameraOverlay = UIStoryboard.camera.instantiateInitialViewController() as? CameraOverlayViewController
        camera = Camera(overlay: cameraOverlay, pickerType: SimulatorImagePickerController.self)
        pdfService = PDFService(fileManager: .default)
        _ = pdfService.deleteList(pdfService.generateList())
        env = AppTestEnvironment(mainViewController: mainViewController, pdfService: pdfService, camera: camera,
                                 cameraOverlay: cameraOverlay)
        env.setInWindow(mainViewController)
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        mainViewController = nil
        cameraOverlay = nil
        camera = nil
        env = nil
        pdfService = nil
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    func testCameraButtonOpensCamera() {
        // mocks
        env.inject()

        // sut
        XCTAssertTrue(mainViewController.cameraButton.fire())

        // test
        XCTAssertTrue(mainViewController.presentedViewController is SimulatorImagePickerController)
    }

    func testListButtonShowsOptionsWhenHavePDFs() {
        // mocks
        env.setNumberOfPDFs(1)
        env.inject()

        // sut
        XCTAssertTrue(mainViewController.listButton.fire())

        // test
        guard let alertController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertEqual(alertController.preferredStyle, .actionSheet)
    }

    func testNoPDFsDisabledListButton() {
        // mocks
        env.inject()

        // test
        XCTAssertFalse(mainViewController.listButton.isEnabled)
    }

    func testPDFsEnableListButton() {
        // mocks
        env.setNumberOfPDFs(1)
        env.inject()

        // test
        XCTAssertTrue(mainViewController.listButton.isEnabled)
    }
}
