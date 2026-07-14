package tests;
import base.BaseTest;
import io.qameta.allure.*;
import org.testng.Assert;
import org.testng.annotations.Test;
import pages.HomePage;
@Epic("TodoApp") @Feature("Search")
public class SearchTodoTest extends BaseTest {
 @Test public void searchUnknownTodoShowsNoResults() {
   HomePage home = new HomePage(driver).search("NoSuchTodo-987654");
   Assert.assertTrue(home.emptyStateVisible(), "No Results state was not shown");
 }
}
