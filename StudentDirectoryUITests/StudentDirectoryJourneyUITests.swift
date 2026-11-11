import XCTest

final class StudentDirectoryJourneyUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testListIsVisibleAfterLaunch() {
        let app = XCUIApplication()
        app.launch()

        let table = app.tables["studentList"]
        XCTAssertTrue(table.waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Ada Lovelace"].exists)
        XCTAssertTrue(app.staticTexts["Alan Turing"].exists)
    }

    func testStudentDetailsAndSubjectNavigation() {
        let app = XCUIApplication()
        app.launch()

        let adaCell = app.cells["studentCell.00000000-0000-0000-0000-000000000001"]
        XCTAssertTrue(adaCell.waitForExistence(timeout: 10))
        adaCell.tap()

        XCTAssertTrue(app.scrollViews["studentDetails"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.navigationBars["Student Details"].exists)
        XCTAssertTrue(app.staticTexts["Ada Lovelace"].exists)

        let mathButton = app.buttons["subjectButton.Math"]
        XCTAssertTrue(mathButton.exists)
        mathButton.tap()

        XCTAssertTrue(app.navigationBars["Math"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Ada Lovelace"].exists)
        XCTAssertTrue(app.staticTexts["Katherine Johnson"].exists)
        XCTAssertTrue(app.staticTexts["Donald Knuth"].exists)
        XCTAssertFalse(app.staticTexts["Alan Turing"].exists)
    }

    func testAddStudentAppearsInList() {
        let app = XCUIApplication()
        app.launch()

        let addButton = app.buttons["addStudentButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 10))
        addButton.tap()

        let nameField = app.textFields["studentNameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Taylor Example")

        let ageField = app.textFields["studentAgeField"]
        ageField.tap()
        ageField.typeText("19")

        app.buttons["saveStudentButton"].tap()

        XCTAssertTrue(app.staticTexts["Taylor Example"].waitForExistence(timeout: 5))
    }
}
