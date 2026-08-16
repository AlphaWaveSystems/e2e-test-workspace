import XCTest

/// Build-verification smoke test — confirms a handful of accessibilityIdentifiers
/// used by the ValueKey-parity table actually resolve at runtime. This is a plain
/// XCTest target (run via `xcodebuild test`), independent of flutter-probe's N-2
/// XCTest/WebDriverAgent bridge, which is what would let flutter-probe's own
/// ProbeScript runner drive this app (see probe-tests/native_suite.probe).
final class ProbeNativeTwinUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testHomeScreenIdentifiersResolve() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["welcome_text"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["version_text"].exists)
        XCTAssertTrue(app.buttons["nav_login"].exists)
        XCTAssertTrue(app.buttons["nav_dashboard"].exists)
        XCTAssertTrue(app.buttons["tab_home"].exists)
        XCTAssertTrue(app.buttons["tab_tests"].exists)
        XCTAssertTrue(app.buttons["tab_about"].exists)
    }

    func testLoginScreenIdentifiersResolve() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["nav_login"].tap()

        XCTAssertTrue(app.textFields["email_field"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.secureTextFields["password_field"].exists)
        XCTAssertTrue(app.buttons["sign_in_button"].exists)
        XCTAssertTrue(app.buttons["forgot_password"].exists)
    }

    func testDashboardReachableWithoutAuth() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["nav_dashboard"].tap()

        XCTAssertTrue(app.staticTexts["welcome_banner"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["stat_card_1"].exists)
        XCTAssertTrue(app.buttons["logout_button"].exists)
    }
}
