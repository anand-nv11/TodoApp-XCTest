package pages;

import io.appium.java_client.ios.IOSDriver;
import org.openqa.selenium.By;

public class AddEditTodoPage extends BasePage {
    private final By title = aid("todoTitleField");
    private final By description = aid("todoDescriptionField");
    private final By save = aid("saveTodoButton");
    private final By cancel = aid("Cancel");
    public AddEditTodoPage(IOSDriver driver) { super(driver); }
    public boolean isLoaded() { return displayed(text("Add Todo")) && displayed(title); }
    public AddEditTodoPage enterTitle(String value) { type(title, value); return this; }
    public AddEditTodoPage enterDescription(String value) { type(description, value); return this; }
    public HomePage save() { tap(save); return new HomePage(driver); }
    public HomePage cancel() { tap(cancel); return new HomePage(driver); }
}
