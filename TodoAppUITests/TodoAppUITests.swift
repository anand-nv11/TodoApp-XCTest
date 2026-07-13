import XCTest

@MainActor
final class TodoAppUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppOpensTodoListScreen() throws {
        let app = makeApp()
        app.launch()

        XCTAssertTrue(app.textFields["todoSearchField"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Add Todo"].exists)
    }

    func testAddTodoAndSearch() throws {
        let app = makeApp()
        app.launch()

        addTodo(title: "Weekly planning", details: "Prepare sprint notes", in: app)

        XCTAssertTrue(app.staticTexts["Weekly planning"].waitForExistence(timeout: 3))

        let searchField = app.textFields["todoSearchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        searchField.tap()
        searchField.typeText("Weekly")

        XCTAssertTrue(app.staticTexts["Weekly planning"].exists)
    }

    func testSwipeDeletesTodo() throws {
        let app = makeApp()
        app.launch()

        addTodo(title: "Delete Me", details: "Remove from list", in: app)
        let todoTitle = app.staticTexts["Delete Me"]
        XCTAssertTrue(todoTitle.waitForExistence(timeout: 3))

        todoTitle.swipeLeft()
        app.buttons["Delete"].tap()

        XCTAssertFalse(todoTitle.waitForExistence(timeout: 2))
    }

    func testViewAllOpensUpcomingTasksScreen() throws {
        let app = makeApp()
        app.launch()

        addTodo(title: "Open upcoming", details: "Navigate to task list", in: app)

        app.buttons["View All"].firstMatch.tap()

        XCTAssertTrue(app.navigationBars["Tasks"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Add Task"].exists)
        XCTAssertTrue(app.textFields["upcomingSearchField"].exists)
    }

    func testMenuTasksOpensPendingTasksScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["Menu"].tap()
        XCTAssertTrue(app.buttons["sideMenuTasks"].waitForExistence(timeout: 3))
        app.buttons["sideMenuTasks"].tap()

        XCTAssertTrue(app.navigationBars["Tasks"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Add Task"].exists)
    }

    func testBottomCalendarOpensCalendarScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["Calendar"].tap()

        XCTAssertTrue(app.navigationBars["Calendar"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Selected Day"].exists)
        XCTAssertTrue(app.staticTexts["All Task Events"].exists)
    }

    func testMenuCalendarOpensCalendarScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["Menu"].tap()
        XCTAssertTrue(app.buttons["sideMenuCalendar"].waitForExistence(timeout: 3))
        app.buttons["sideMenuCalendar"].tap()

        XCTAssertTrue(app.navigationBars["Calendar"].waitForExistence(timeout: 3))
    }

    func testHomeSettingsOpensSettingsScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["homeSettingsButton"].tap()

        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["App Details"].exists)
    }

    func testHomeListsViewAllOpensListsScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["ListsViewAllButton"].tap()

        XCTAssertTrue(app.navigationBars["Lists"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Personal Tasks"].exists)
    }

    func testHomeGoalsViewAllOpensGoalsScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["GoalsViewAllButton"].tap()

        XCTAssertTrue(app.navigationBars["Goals"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Weekly Goals"].exists)
    }

    func testMenuSettingsOpensSettingsScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["Menu"].tap()
        XCTAssertTrue(app.buttons["sideMenuSettings"].waitForExistence(timeout: 3))
        app.buttons["sideMenuSettings"].tap()

        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 3))
    }

    func testMenuListsOpensListsScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["Menu"].tap()
        XCTAssertTrue(app.buttons["sideMenuLists"].waitForExistence(timeout: 3))
        app.buttons["sideMenuLists"].tap()

        XCTAssertTrue(app.navigationBars["Lists"].waitForExistence(timeout: 3))
    }

    func testMenuGoalsOpensGoalsScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["Menu"].tap()
        XCTAssertTrue(app.buttons["sideMenuGoals"].waitForExistence(timeout: 3))
        app.buttons["sideMenuGoals"].tap()

        XCTAssertTrue(app.navigationBars["Goals"].waitForExistence(timeout: 3))
    }

    func testHomeNotificationsOpensNotificationsScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["homeNotificationsButton"].tap()

        XCTAssertTrue(app.navigationBars["Notifications"].waitForExistence(timeout: 3))
    }

    func testMenuNotificationOpensNotificationsScreen() throws {
        let app = makeApp()
        app.launch()

        app.buttons["Menu"].tap()
        XCTAssertTrue(app.buttons["sideMenuNotification"].waitForExistence(timeout: 3))
        app.buttons["sideMenuNotification"].tap()

        XCTAssertTrue(app.navigationBars["Notifications"].waitForExistence(timeout: 3))
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            makeApp().launch()
        }
    }

    private func makeApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTesting"]
        return app
    }

    private func addTodo(title: String, details: String, in app: XCUIApplication) {
        XCTAssertTrue(app.textFields["todoSearchField"].waitForExistence(timeout: 3))
        app.buttons["Add Todo"].tap()

        let titleField = app.textFields["todoTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 3))
        titleField.tap()
        titleField.typeText(title)

        let detailsField = app.textFields["todoDescriptionField"]
        XCTAssertTrue(detailsField.waitForExistence(timeout: 3))
        detailsField.tap()
        detailsField.typeText(details)

        app.buttons["saveTodoButton"].tap()
    }
}
