package base;

import io.appium.java_client.ios.IOSDriver;
import io.appium.java_client.ios.options.XCUITestOptions;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import java.net.MalformedURLException;
import java.net.URI;
import java.time.Duration;

public abstract class BaseTest {
    protected IOSDriver driver;

    @BeforeMethod(alwaysRun = true)
    public void setUp() throws MalformedURLException {
        String serverUrl = property("appiumServerUrl", "http://127.0.0.1:4723");
        XCUITestOptions options = new XCUITestOptions()
                .setDeviceName(property("deviceName", "iPhone 17"))
                .setPlatformVersion(property("platformVersion", "26.4"))
                .setBundleId(property("bundleId", "test.com.TodoApp"))
                .setNoReset(Boolean.parseBoolean(property("noReset", "true")))
                .setNewCommandTimeout(Duration.ofSeconds(300))
                .setWdaLaunchTimeout(Duration.ofSeconds(180))
                .setWdaConnectionTimeout(Duration.ofSeconds(180));

        String udid = System.getProperty("udid", System.getenv("DEVICE_ID"));
        if (udid != null && !udid.isBlank()) options.setUdid(udid);

        String appPath = System.getProperty("appPath", System.getenv("APP_PATH"));
        if (appPath != null && !appPath.isBlank()) options.setApp(appPath);

        driver = new IOSDriver(URI.create(serverUrl).toURL(), options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(2));
        DriverManager.setDriver(driver);
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown() {
        if (driver != null) driver.quit();
        DriverManager.unload();
    }

    private static String property(String name, String defaultValue) {
        String value = System.getProperty(name);
        return value == null || value.isBlank() ? defaultValue : value;
    }
}
