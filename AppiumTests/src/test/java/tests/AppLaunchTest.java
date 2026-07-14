package tests;
import base.BaseTest;
import io.qameta.allure.*;
import org.testng.Assert;
import org.testng.annotations.Test;
import pages.HomePage;
@Epic("TodoApp") @Feature("Launch")
public class AppLaunchTest extends BaseTest {
 @Test @Severity(SeverityLevel.BLOCKER) @Description("Verify TodoApp opens on the Home dashboard")
 public void verifyAppLaunch() { Assert.assertTrue(new HomePage(driver).isLoaded(), "Home screen did not load"); }
}
