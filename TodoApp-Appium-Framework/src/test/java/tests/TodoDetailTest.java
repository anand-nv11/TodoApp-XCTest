package tests;
import base.BaseTest;
import io.qameta.allure.*;
import org.testng.Assert;
import org.testng.annotations.Test;
import pages.HomePage;
import pages.TodoDetailPage;
@Epic("TodoApp") @Feature("Todo Details")
public class TodoDetailTest extends BaseTest {
 @Test public void openCreatedTodoDetails() {
   String title = "Detail Todo " + System.currentTimeMillis();
   String description = "Detail screen verification";
   HomePage home = new HomePage(driver);
   home.openAddTodo().enterTitle(title).enterDescription(description).save();
   TodoDetailPage details = home.openTodo(title);
   Assert.assertTrue(details.isLoaded());
   Assert.assertTrue(details.showsTitle(title));
   Assert.assertTrue(details.showsDescription(description));
 }
}
