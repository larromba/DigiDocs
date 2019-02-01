import AsyncAwait
@testable import DigiDocs
import TestExtensions
import XCTest

final class NameDialogueTests: XCTestCase {
    private var homeViewController: HomeViewController!
    private var env: AppTestEnvironment!

    override func setUp() {
        super.setUp()
        homeViewController = UIStoryboard.main.instantiateInitialViewController() as? HomeViewController
        env = AppTestEnvironment(homeViewController: homeViewController)
        env.setInWindow(homeViewController)
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        homeViewController = nil
        env = nil
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    func testNoTextDisabledOK() {
        // mocks
        env.inject()
        async({
            try await(self.env.namingController.getName())
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })

        // test
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertFalse(alertController.actions[safe: 1]?.isEnabled ?? true)
    }

    func testTextEnablesOK() {
        // mocks
        env.inject()
        async({
            try await(self.env.namingController.getName())
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        alertController.textFields?.first?.setText("test")

        // test
        waitSync()
        XCTAssertTrue(alertController.actions[safe: 1]?.isEnabled ?? false)
    }

    func testRandomChoosesRandomFileName() {
        // mocks
        env.inject()
        var name: String = ""
        async({
            name = try await(self.env.namingController.getName())
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertTrue(alertController.actions[safe: 2]?.fire() ?? false)

        // test
        waitSync()
        XCTAssertEqual(name.count, 36)
    }

    func testCancelClosesDialogue() {
        // mocks
        env.inject()
        async({
            try await(self.env.namingController.getName())
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertTrue(alertController.tapButton(at: 0))

        // test
        waitSync()
        XCTAssertNil(homeViewController.presentedViewController)
    }

    func testOkChoosesEnteredName() {
        // mocks
        env.inject()
        var name: String = ""
        async({
            name = try await(self.env.namingController.getName())
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        alertController.textFields?.first?.setText("test")
        XCTAssertTrue(alertController.actions[safe: 1]?.fire() ?? false)

        // test
        waitSync()
        XCTAssertEqual(name, "test")
    }
}
