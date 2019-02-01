@testable import DigiDocs
import TestExtensions
import XCTest

final class OptionsDialogueTests: XCTestCase {
    private var homeViewController: HomeViewController!
    private var pdfService: PDFService!
    private var env: AppTestEnvironment!

    override func setUp() {
        super.setUp()
        homeViewController = UIStoryboard.main.instantiateInitialViewController() as? HomeViewController
        pdfService = PDFService(fileManager: .default)
        _ = pdfService.deleteList(pdfService.generateList())
        env = AppTestEnvironment(homeViewController: homeViewController, pdfService: pdfService)
        env.setNumberOfPDFs(2)
        env.setInWindow(homeViewController)
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        homeViewController = nil
        pdfService = nil
        env = nil
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    func testViewAllOpensAllPDFs() {
        // mocks
        env.inject()
        XCTAssertTrue(homeViewController.listButton.fire())

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        alertController.tapButton(at: 0)

        // test
        waitSync()
        XCTAssertTrue(homeViewController.presentedViewController is PDFViewController)
    }

    func testShareAllOpensShareDialogue() {
        // mocks
        env.inject()
        XCTAssertTrue(homeViewController.listButton.fire())

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        alertController.tapButton(at: 1)

        // test
        waitSync()
        XCTAssertTrue(homeViewController.presentedViewController is UIActivityViewController)
    }

    func testDeleteAllDeletesAllPDFs() {
        // mocks
        env.inject()
        XCTAssertTrue(homeViewController.listButton.fire())

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        alertController.tapButton(at: 2)
        waitSync()
        guard let confirmationController = homeViewController.presentedViewController as? UIAlertController else {
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
        XCTAssertTrue(homeViewController.listButton.fire())

        // precondition
        XCTAssertTrue(homeViewController.listButton.isEnabled)

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        alertController.tapButton(at: 2)
        waitSync()
        guard let confirmationController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        confirmationController.tapButton(at: 1)

        // test
        waitSync()
        XCTAssertFalse(homeViewController.listButton.isEnabled)
    }
}
