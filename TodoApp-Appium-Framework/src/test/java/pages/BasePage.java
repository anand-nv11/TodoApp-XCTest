package pages;

import io.appium.java_client.AppiumBy;
import io.appium.java_client.ios.IOSDriver;
import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;

public abstract class BasePage {
    protected final IOSDriver driver;
    protected final WebDriverWait wait;
    protected BasePage(IOSDriver driver) { this.driver = driver; this.wait = new WebDriverWait(driver, Duration.ofSeconds(20)); }
    protected WebElement visible(By by) { return wait.until(ExpectedConditions.visibilityOfElementLocated(by)); }
    protected WebElement clickable(By by) { return wait.until(ExpectedConditions.elementToBeClickable(by)); }
    protected void tap(By by) { clickable(by).click(); }
    protected void type(By by, String text) { WebElement e = visible(by); e.clear(); e.sendKeys(text); }
    protected boolean displayed(By by) { try { return visible(by).isDisplayed(); } catch (TimeoutException | NoSuchElementException e) { return false; } }
    protected By aid(String id) { return AppiumBy.accessibilityId(id); }
    protected By text(String value) { return AppiumBy.iOSNsPredicateString("label == '" + value.replace("'", "\\'") + "' OR name == '" + value.replace("'", "\\'") + "'"); }
}
