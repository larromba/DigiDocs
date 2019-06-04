@testable import DigiDocs
import TestExtensions
import XCTest

final class HomeTests: XCTestCase {
    private var homeViewController: HomeViewController!
    private var camera: Camera!
    private var cameraOverlay: CameraOverlayViewController!
    private var env: AppTestEnvironment!
    private var pdfService: PDFService!
    private var badge: MockBadge!

    override func setUp() {
        super.setUp()
        homeViewController = UIStoryboard.main.instantiateInitialViewController() as? HomeViewController
        cameraOverlay = UIStoryboard.camera.instantiateInitialViewController() as? CameraOverlayViewController
        camera = Camera(overlay: cameraOverlay, pickerType: SimulatorImagePickerController.self)
        pdfService = PDFService(fileManager: .default)
        badge = MockBadge()
        env = AppTestEnvironment(homeViewController: homeViewController, pdfService: pdfService, camera: camera,
                                 cameraOverlay: cameraOverlay, badge: badge)
        env.setInWindow(homeViewController)
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        homeViewController = nil
        cameraOverlay = nil
        camera = nil
        env = nil
        _ = pdfService.deleteList(pdfService.generateList())
        pdfService = nil
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    func testCameraButtonOpensCamera() {
        // mocks
        env.inject()

        // sut
        XCTAssertTrue(homeViewController.cameraButton.fire())

        // test
        XCTAssertTrue(homeViewController.presentedViewController is SimulatorImagePickerController)
    }

    func testListButtonShowsOptionsWhenHavePDFs() {
        // mocks
        env.setNumberOfPDFs(1)
        env.inject()

        // sut
        XCTAssertTrue(homeViewController.listButton.fire())

        // test
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertEqual(alertController.preferredStyle, .actionSheet)
    }

    func testListButtonBadgeShowsNumberOfPDFs() {
        // mocks
        env.setNumberOfPDFs(1)
        env.inject()

        // test
        XCTAssertEqual(homeViewController.listBadgeLabel?.text, "1")
    }

    func testAppBadgeShowsNumberOfPDFs() {
        // mocks
        env.setNumberOfPDFs(1)
        env.inject()

        // test
        XCTAssertEqual(badge.invocations.find(MockBadge.setNumber1.name).first?
            .parameter(for: MockBadge.setNumber1.params.number) as? Int ?? 0, 1)
    }

    func testNoPDFsDisabledListButton() {
        // mocks
        env.inject()

        // test
        XCTAssertFalse(homeViewController.listButton.isEnabled)
    }

    func testPDFsEnableListButton() {
        // mocks
        env.setNumberOfPDFs(1)
        env.inject()

        // test
        XCTAssertTrue(homeViewController.listButton.isEnabled)
    }
}
