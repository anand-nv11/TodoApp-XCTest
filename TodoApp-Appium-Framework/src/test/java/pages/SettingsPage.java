package pages;
import io.appium.java_client.ios.IOSDriver;
public class SettingsPage extends BasePage {
    public SettingsPage(IOSDriver driver) { super(driver); }
    public boolean isLoaded() { return displayed(text("Settings")); }
    public boolean userProfileVisible() { return displayed(text("Todo Nv")) && displayed(text("test@email.com")); }
}
