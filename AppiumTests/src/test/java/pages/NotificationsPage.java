package pages;
import io.appium.java_client.ios.IOSDriver;
public class NotificationsPage extends BasePage {
    public NotificationsPage(IOSDriver driver) { super(driver); }
    public boolean isLoaded() { return displayed(text("Notifications")); }
    public boolean subtitleVisible() { return displayed(text("Task reminders and status updates")); }
}
