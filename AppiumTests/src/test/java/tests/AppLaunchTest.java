package tests;

import base.BaseTest;
import org.testng.Assert;
import org.testng.annotations.Test;

public class AppLaunchTest extends BaseTest {

 @Test
 public void verifyAppLaunch() {
  System.out.println("AppLaunchTest started");

  Assert.assertNotNull(
          driver,
          "IOSDriver was not initialized"
  );

  System.out.println("Session ID: " + driver.getSessionId());
  System.out.println("AppLaunchTest completed");
 }
}