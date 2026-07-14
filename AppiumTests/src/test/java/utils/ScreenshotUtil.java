package utils;

import base.DriverManager;
import io.qameta.allure.Allure;
import org.openqa.selenium.OutputType;
import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public final class ScreenshotUtil {
    private ScreenshotUtil() {}
    public static void capture(String name) {
        if (DriverManager.getDriver() == null) return;
        byte[] bytes = DriverManager.getDriver().getScreenshotAs(OutputType.BYTES);
        try {
            Files.createDirectories(Path.of("screenshots"));
            String stamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd-HHmmss"));
            Files.write(Path.of("screenshots", sanitize(name) + "-" + stamp + ".png"), bytes);
            Allure.addAttachment(name, "image/png", new ByteArrayInputStream(bytes), ".png");
        } catch (IOException e) { System.err.println("Could not save screenshot: " + e.getMessage()); }
    }
    private static String sanitize(String value) { return value.replaceAll("[^a-zA-Z0-9._-]", "_"); }
}
