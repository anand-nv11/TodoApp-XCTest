package tests;
import base.BaseTest;
import org.testng.Assert;
import org.testng.annotations.Test;
import pages.SettingsPage;
import pages.HomePage;
public class SettingsTest extends BaseTest {
 @Test public void openSettings() { SettingsPage page = new HomePage(driver).openSettings(); Assert.assertTrue(page.isLoaded()); Assert.assertTrue(page.userProfileVisible()); }
}
