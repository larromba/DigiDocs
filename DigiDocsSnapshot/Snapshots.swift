import XCTest

final class Snapshots: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        setupSnapshot(app)
        continueAfterFailure = false
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testMainSnapshot() {
        // main
        app.launch()
        snapshot("Main")

        // camera
        XCUIApplication().buttons["camera"].tap()
        snapshot("Camera")

        // naming
        app.buttons["Take"].tap()
        app.buttons["Done"].tap()
        snapshot("Naming")

        // pdf view
        app.alerts["Document Name"].buttons["Random"].tap()
        snapshot("PDF")
    }
}
