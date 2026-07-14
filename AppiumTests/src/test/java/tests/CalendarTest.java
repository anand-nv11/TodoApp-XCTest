package tests;
import base.BaseTest;
import org.testng.Assert;
import org.testng.annotations.Test;
import pages.CalendarPage;
import pages.HomePage;
public class CalendarTest extends BaseTest {
 @Test public void openCalendar() { CalendarPage page = new HomePage(driver).openCalendar(); Assert.assertTrue(page.isLoaded()); Assert.assertTrue(page.datePickerVisible()); }
}
