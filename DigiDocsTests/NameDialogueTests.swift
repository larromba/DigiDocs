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

    // MARK: - text

    func test_text_whenEmpty_expectOKButtonDisabled() {
        // mocks
        env.inject()
        env.namingController.getName()

        // test
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        XCTAssertFalse(alertController.actions[safe: 1]?.isEnabled ?? true)
    }

    func test_text_whenEntered_expectOKButtonEnabled() {
        // mocks
        env.inject()
        env.namingController.getName()

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

    func test_text_whenChosen_expectIsValidFilePath() {
        // mocks
        let delegate = MockNamingControllerDelegate()
        env.inject()
        env.namingController.getName()

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        env.namingController.setDelegate(delegate) // intercepting delegate calls after alert appears
        alertController.textFields?.first?.setText("a-\\te/st|..na:me")
        XCTAssertTrue(alertController.actions[safe: 1]?.fire() ?? false)

        // test
        waitSync()
        let name = delegate.invocations
            .find(MockNamingControllerDelegate.controller1.name).first?
            .parameter(for: MockNamingControllerDelegate.controller1.params.name) as? String
        XCTAssertEqual(name, "a-test|name")
    }

    // MARK: - button

    func test_randomButton_whenPressed_expectChoosesRandomName() {
        // mocks
        let delegate = MockNamingControllerDelegate()
        env.inject()
        env.namingController.getName()

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        env.namingController.setDelegate(delegate) // intercepting delegate calls after alert appears
        XCTAssertTrue(alertController.actions[safe: 2]?.fire() ?? false)

        // test
        waitSync()
        let name = delegate.invocations
            .find(MockNamingControllerDelegate.controller1.name).first?
            .parameter(for: MockNamingControllerDelegate.controller1.params.name) as? String
        XCTAssertEqual(name?.count, 36)
    }

    func test_cancelButton_whenPressed_expectDialogueCloses() {
        // mocks
        env.inject()
        env.namingController.getName()

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

    func test_okButton_whenPressed_expectChoosesName() {
        // mocks
        let delegate = MockNamingControllerDelegate()
        env.inject()
        env.namingController.getName()

        // sut
        waitSync()
        guard let alertController = homeViewController.presentedViewController as? UIAlertController else {
            XCTFail("expected UIAlertController")
            return
        }
        env.namingController.setDelegate(delegate) // intercepting delegate calls after alert appears
        alertController.textFields?.first?.setText("test")
        XCTAssertTrue(alertController.actions[safe: 1]?.fire() ?? false)

        // test
        waitSync()
        let name = delegate.invocations
            .find(MockNamingControllerDelegate.controller1.name).first?
            .parameter(for: MockNamingControllerDelegate.controller1.params.name) as? String
        XCTAssertEqual(name, "test")
    }
}
