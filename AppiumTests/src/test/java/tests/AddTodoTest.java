package tests;
import base.BaseTest;
import io.qameta.allure.*;
import org.testng.Assert;
import org.testng.annotations.Test;
import pages.HomePage;
@Epic("TodoApp") @Feature("Create Todo")
public class AddTodoTest extends BaseTest {
 @Test @Severity(SeverityLevel.CRITICAL)
 public void addNewTodo() {
   String title = "Appium Todo " + System.currentTimeMillis();
   HomePage home = new HomePage(driver);
   home.openAddTodo().enterTitle(title).enterDescription("Created by Appium automation").save();
   Assert.assertTrue(home.hasTodo(title), "Created todo was not visible: " + title);
 }
}
