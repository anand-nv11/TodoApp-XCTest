package tests;
import base.BaseTest;
import io.qameta.allure.*;
import org.testng.Assert;
import org.testng.annotations.Test;
import pages.HomePage;
@Epic("TodoApp") @Feature("Navigation")
public class NavigationTest extends BaseTest {
 @Test public void openTasksFromSideMenu() {
   HomePage home = new HomePage(driver); home.openMenu().openSideMenuItem("Tasks");
   Assert.assertTrue(driver.getPageSource().contains("Tasks"), "Tasks screen did not open");
 }
}
