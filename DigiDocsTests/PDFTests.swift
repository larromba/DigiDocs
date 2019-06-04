@testable import DigiDocs
import TestExtensions
import XCTest

final class PDFTests: XCTestCase {
    private var homeViewController: HomeViewController!
    private var camera: Camera!
    private var cameraOverlay: CameraOverlayViewController!
    private var env: AppTestEnvironment!
    private var pdfService: PDFService!
    private var pdfViewController: PDFViewController!

    override func setUp() {
        super.setUp()
        homeViewController = UIStoryboard.main.instantiateInitialViewController() as? HomeViewController
        cameraOverlay = UIStoryboard.camera.instantiateInitialViewController() as? CameraOverlayViewController
        camera = Camera(overlay: cameraOverlay, pickerType: SimulatorImagePickerController.self)
        pdfService = PDFService(fileManager: .default)
        pdfViewController = PDFViewController(viewState: PDFViewState(paths: []))
        env = AppTestEnvironment(homeViewController: homeViewController, pdfService: pdfService, camera: camera,
                                 cameraOverlay: cameraOverlay, pdfViewController: pdfViewController)
        env.setInWindow(homeViewController)
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        homeViewController = nil
        cameraOverlay = nil
        camera = nil
        _ = pdfService.deleteList(pdfService.generateList())
        pdfService = nil
        pdfViewController = nil
        env = nil
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    func testChoosingNameAndTakingPictureGeneratesPDF() {
        // mocks
        env.inject()
        XCTAssertTrue(homeViewController.cameraButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())
        XCTAssertTrue(cameraOverlay.doneButton.fire())
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
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
        XCTAssertTrue(homeViewController.cameraButton.fire())
        XCTAssertTrue(cameraOverlay.takeButton.fire())
        XCTAssertTrue(cameraOverlay.doneButton.fire())
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertTrue(alertController.tapButton(at: 2))

        // test
        waitSync(for: 2.0)
        XCTAssertTrue(homeViewController.presentedViewController is PDFViewController)
    }
}
