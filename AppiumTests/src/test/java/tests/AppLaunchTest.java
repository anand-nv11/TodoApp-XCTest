package tests;

import base.BaseTest;
import org.testng.Assert;
import org.testng.annotations.Test;

public class AppLaunchTest extends BaseTest {

 @Test
 public void verifyAppLaunch() {
  System.out.println("AppLaunchTest is running");

  Assert.assertNotNull(
          driver,
          "The Appium driver was not created"
  );

  Assert.assertNotNull(
          driver.getSessionId(),
          "The Appium session was not created"
  );
 }
}