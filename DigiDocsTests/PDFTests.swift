@testable import DigiDocs
import TestExtensions
import XCTest

final class PDFTests: XCTestCase {
    private var mainViewController: MainViewController!
    private var camera: Camera!
    private var cameraOverlay: CameraOverlayViewController!
    private var env: AppTestEnvironment!
    private var pdfService: PDFService!
    private var pdfViewController: PDFViewController!

    override func setUp() {
        super.setUp()
        mainViewController = UIStoryboard.main.instantiateInitialViewController() as? MainViewController
        cameraOverlay = UIStoryboard.camera.instantiateInitialViewController() as? CameraOverlayViewController
        camera = Camera(overlay: cameraOverlay, pickerType: SimulatorImagePickerController.self)
        pdfService = PDFService(fileManager: .default)
        _ = pdfService.deleteList(pdfService.generateList())
        pdfViewController = PDFViewController(viewState: PDFViewState(paths: []))
        env = AppTestEnvironment(mainViewController: mainViewController, pdfService: pdfService, camera: camera,
                                 cameraOverlay: cameraOverlay, pdfViewController: pdfViewController)
        env.setInWindow(mainViewController)
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        mainViewController = nil
        cameraOverlay = nil
        camera = nil
        pdfService = nil
        pdfViewController = nil
        env = nil
        UIView.setAnimationsEnabled(true)
        SimulatorImagePickerController.isSourceTypeAvailable = true
        super.tearDown()
    }

    func testChoosingNameAndTakingPictureGeneratesPDF() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.cameraButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())
        XCTAssertTrue(cameraOverlay.doneButton.fire())
        waitSync()
        guard let alertController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertTrue(alertController.actions[safe: 2]?.fire() ?? false)

        // test
        waitSync()
        XCTAssertEqual(env.pdfService.generateList().paths.count, 1)
    }

    func testPDFOpensInViewAfterGeneration() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.cameraButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())
        XCTAssertTrue(cameraOverlay.doneButton.fire())
        waitSync()
        guard let alertController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertTrue(alertController.tapButton(at: 2))

        // test
        waitSync(for: 2.0)
        XCTAssertTrue(mainViewController.presentedViewController is PDFViewController)
    }
}
