package pages;

import io.appium.java_client.AppiumBy;
import io.appium.java_client.ios.IOSDriver;
import org.openqa.selenium.By;

public class HomePage extends BasePage {
    private final By search = aid("todoSearchField");
    private final By addTodo = aid("Add Todo");
    private final By calendar = aid("Calendar");
    private final By menu = aid("Menu");
    private final By settings = aid("homeSettingsButton");
    private final By notifications = aid("homeNotificationsButton");

    public HomePage(IOSDriver driver) { super(driver); }
    public boolean isLoaded() { return displayed(search) && displayed(text("Home")); }
    public AddEditTodoPage openAddTodo() { tap(addTodo); return new AddEditTodoPage(driver); }
    public HomePage search(String value) { type(search, value); return this; }
    public boolean hasTodo(String title) { return displayed(AppiumBy.iOSNsPredicateString("label == '" + title + "' OR name == '" + title + "'")); }
    public TodoDetailPage openTodo(String title) { tap(AppiumBy.iOSNsPredicateString("label == '" + title + "' OR name == '" + title + "'")); return new TodoDetailPage(driver); }
    public CalendarPage openCalendar() { tap(calendar); return new CalendarPage(driver); }
    public SettingsPage openSettings() { tap(settings); return new SettingsPage(driver); }
    public NotificationsPage openNotifications() { tap(notifications); return new NotificationsPage(driver); }
    public HomePage openMenu() { tap(menu); return this; }
    public void openSideMenuItem(String title) { tap(aid("sideMenu" + title)); }
    public boolean emptyStateVisible() { return displayed(text("No Todos Yet")) || displayed(text("No Results")); }
}
