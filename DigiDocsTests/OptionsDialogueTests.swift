@testable import DigiDocs
import TestExtensions
import XCTest

final class OptionsDialogueTests: XCTestCase {
    private var mainViewController: MainViewController!
    private var pdfService: PDFService!
    private var env: AppTestEnvironment!

    override func setUp() {
        super.setUp()
        mainViewController = UIStoryboard.main.instantiateInitialViewController() as? MainViewController
        pdfService = PDFService(fileManager: .default)
        _ = pdfService.deleteList(pdfService.generateList())
        env = AppTestEnvironment(mainViewController: mainViewController, pdfService: pdfService)
        env.setNumberOfPDFs(2)
        env.setInWindow(mainViewController)
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        mainViewController = nil
        pdfService = nil
        env = nil
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    func testViewAllOpensAllPDFs() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.listButton.fire())

        // sut
        waitSync()
        guard let alertController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        alertController.tapButton(at: 0)

        // test
        waitSync()
        XCTAssertTrue(mainViewController.presentedViewController is PDFViewController)
    }

    func testShareAllOpensShareDialogue() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.listButton.fire())

        // sut
        waitSync()
        guard let alertController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        alertController.tapButton(at: 1)

        // test
        waitSync()
        XCTAssertTrue(mainViewController.presentedViewController is UIActivityViewController)
    }

    func testDeleteAllDeletesAllPDFs() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.listButton.fire())

        // sut
        waitSync()
        guard let alertController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        alertController.tapButton(at: 2)
        waitSync()
        guard let confirmationController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        confirmationController.tapButton(at: 1)

        // test
        waitSync()
        XCTAssertEqual(pdfService.generateList().paths.count, 0)
    }

    func testMainUIUpdatesAfterDelete() {
        // mocks
        env.inject()
        XCTAssertTrue(mainViewController.listButton.fire())

        // precondition
        XCTAssertTrue(mainViewController.listButton.isEnabled)

        // sut
        waitSync()
        guard let alertController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        alertController.tapButton(at: 2)
        waitSync()
        guard let confirmationController = mainViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        confirmationController.tapButton(at: 1)

        // test
        waitSync()
        XCTAssertFalse(mainViewController.listButton.isEnabled)
    }
}
