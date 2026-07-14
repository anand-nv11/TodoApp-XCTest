package tests;
import base.BaseTest;
import org.testng.Assert;
import org.testng.annotations.Test;
import pages.HomePage;
import pages.NotificationsPage;
public class NotificationsTest extends BaseTest {
 @Test public void openNotifications() { NotificationsPage page = new HomePage(driver).openNotifications(); Assert.assertTrue(page.isLoaded()); Assert.assertTrue(page.subtitleVisible()); }
}
