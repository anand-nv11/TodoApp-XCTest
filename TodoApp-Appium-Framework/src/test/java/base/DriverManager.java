package base;

import io.appium.java_client.ios.IOSDriver;

public final class DriverManager {
    private static final ThreadLocal<IOSDriver> DRIVER = new ThreadLocal<>();
    private DriverManager() {}
    public static IOSDriver getDriver() { return DRIVER.get(); }
    public static void setDriver(IOSDriver driver) { DRIVER.set(driver); }
    public static void unload() { DRIVER.remove(); }
}
