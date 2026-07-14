# TodoApp iOS Appium Automation Framework

Java 17 + Appium + XCUITest + TestNG + Maven + Allure Page Object Model framework created for the supplied SwiftUI TodoApp views.

## Included tests

- App launch
- Add todo
- Search/no-results
- Todo details
- Side-menu navigation
- Settings
- Notifications
- Calendar
- Automatic screenshots on failure
- Allure results
- GitHub Actions workflow

## Prerequisites

Install Appium and XCUITest:

```bash
npm install -g appium
appium driver install xcuitest
```

Boot the simulator and start Appium:

```bash
open -a Simulator
appium --log-level debug
```

Confirm the app is installed:

```bash
xcrun simctl get_app_container booted test.com.TodoApp
```

## Run

```bash
mvn clean test \
  -DbundleId=test.com.TodoApp \
  -Dudid="YOUR-SIMULATOR-UDID" \
  -DdeviceName="iPhone 17" \
  -DplatformVersion="26.4"
```

For a local `.app` build, also pass:

```bash
-DappPath="/absolute/path/to/TodoApp.app"
```

Generate an Allure report:

```bash
allure serve allure-results
```

## Important SwiftUI identifiers used

- `todoTitleField`
- `todoDescriptionField`
- `todoDueTimePicker`
- `saveTodoButton`
- `todoSearchField`
- `homeSettingsButton`
- `homeNotificationsButton`
- `sideMenuTasks`, `sideMenuLists`, `sideMenuGoals`, `sideMenuCalendar`, `sideMenuSettings`, `sideMenuNotification`

The bottom buttons currently rely on accessibility labels `Add Todo` and `Calendar`. For maximum reliability, add explicit identifiers such as `addTodoButton` and `homeCalendarButton` in SwiftUI.

## Repository placement

Copy this folder into your repository as `AppiumTests`:

```text
TodoApp-XCTest/
├── TodoApp-XCTest.xcodeproj
├── AppiumTests/
└── .github/workflows/
```

The included workflow assumes project `TodoApp-XCTest.xcodeproj`, scheme `TodoApp-XCTest`, bundle ID `test.com.TodoApp`, Xcode 26.4.1, and iOS 26.4. Change them if your actual names differ.
