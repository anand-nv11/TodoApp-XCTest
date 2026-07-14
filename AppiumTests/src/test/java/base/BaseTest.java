package base;

import io.appium.java_client.ios.IOSDriver;
import io.appium.java_client.ios.options.XCUITestOptions;
import org.openqa.selenium.WebDriverException;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;

import java.net.URI;
import java.net.URL;
import java.time.Duration;

public class BaseTest {

    protected IOSDriver driver;

    @BeforeMethod(alwaysRun = true)
    public void setUp() throws Exception {

        String serverUrl = System.getProperty(
                "appiumServerUrl",
                "http://127.0.0.1:4723"
        );

        String bundleId = System.getProperty(
                "bundleId",
                "test.com.TodoApp"
        );

        String udid = System.getProperty("udid");

        String deviceName = System.getProperty(
                "deviceName",
                "iPhone 17"
        );

        String platformVersion = System.getProperty(
                "platformVersion",
                "26.4"
        );

        if (udid == null || udid.isBlank()) {
            throw new IllegalArgumentException(
                    "Simulator UDID is missing. " +
                            "Run Maven with -Dudid=YOUR_SIMULATOR_UDID"
            );
        }

        XCUITestOptions options = new XCUITestOptions()
                .setDeviceName(deviceName)
                .setPlatformVersion(platformVersion)
                .setUdid(udid)
                .setBundleId(bundleId)
                .setNoReset(true)
                .setNewCommandTimeout(Duration.ofSeconds(300))
                .setWdaLaunchTimeout(Duration.ofSeconds(180))
                .setWdaConnectionTimeout(Duration.ofSeconds(180));

        URL appiumUrl = URI.create(serverUrl).toURL();

        System.out.println("====================================");
        System.out.println("Appium server: " + appiumUrl);
        System.out.println("Device name: " + deviceName);
        System.out.println("Platform version: " + platformVersion);
        System.out.println("Simulator UDID: " + udid);
        System.out.println("Bundle ID: " + bundleId);
        System.out.println("====================================");

        try {
            driver = new IOSDriver(appiumUrl, options);

            driver.manage()
                    .timeouts()
                    .implicitlyWait(Duration.ofSeconds(5));

            System.out.println("Appium session created successfully.");
            System.out.println("Session ID: " + driver.getSessionId());

        } catch (WebDriverException error) {
            System.err.println("Unable to create Appium session.");
            System.err.println("Appium URL: " + appiumUrl);
            System.err.println("Error type: " + error.getClass().getName());
            System.err.println("Error message: " + error.getMessage());

            Throwable cause = error.getCause();

            while (cause != null) {
                System.err.println(
                        "Caused by: " +
                                cause.getClass().getName() +
                                ": " +
                                cause.getMessage()
                );

                cause = cause.getCause();
            }

            error.printStackTrace();
            throw error;
        }
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown() {
        if (driver != null) {
            try {
                driver.quit();
            } catch (Exception error) {
                System.err.println(
                        "Unable to close Appium session: " +
                                error.getMessage()
                );
            } finally {
                driver = null;
            }
        }
    }
}