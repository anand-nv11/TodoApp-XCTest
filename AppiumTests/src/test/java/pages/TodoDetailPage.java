package pages;

import io.appium.java_client.ios.IOSDriver;
public class TodoDetailPage extends BasePage {
    public TodoDetailPage(IOSDriver driver) { super(driver); }
    public boolean isLoaded() { return displayed(text("Todo Details")); }
    public boolean showsTitle(String title) { return displayed(text(title)); }
    public boolean showsDescription(String description) { return displayed(text(description)); }
}
