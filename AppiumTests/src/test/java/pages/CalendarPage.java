package pages;
import io.appium.java_client.ios.IOSDriver;
public class CalendarPage extends BasePage {
    public CalendarPage(IOSDriver driver) { super(driver); }
    public boolean isLoaded() { return displayed(text("Calendar")); }
    public boolean datePickerVisible() { return displayed(text("Select Date")); }
}
