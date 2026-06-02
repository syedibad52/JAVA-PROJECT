package util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class DBUtil {

    // Loaded .env values cached here
    private static final Map<String, String> ENV = new HashMap<>();

    static {
        // Step 1: Load .env file if it exists (local development)
        loadDotEnv();

        // Step 2: Load MySQL JDBC Driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                "MySQL JDBC Driver not found! Ensure mysql-connector-j jar is in the classpath.", e);
        }
    }

    // Priority: .env file → OS environment variable → hardcoded default
    private static final String URL      = resolve("DB_URL",
            "jdbc:mysql://localhost:3306/course_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
    private static final String USER     = resolve("DB_USER",     "root");
    private static final String PASSWORD = resolve("DB_PASSWORD", "syedsyed");

    /**
     * Reads the .env file from the project root and populates the ENV map.
     * Lines starting with '#' are treated as comments and skipped.
     * Only active on local development; on Render the OS env vars take priority.
     */
    private static void loadDotEnv() {
        // Search for .env relative to the working directory
        String[] searchPaths = {
            ".env",
            "../.env",
            "../../.env"
        };

        for (String path : searchPaths) {
            File envFile = new File(path);
            if (envFile.exists()) {
                try (BufferedReader reader = new BufferedReader(new FileReader(envFile))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        line = line.trim();
                        // Skip blank lines and comments
                        if (line.isEmpty() || line.startsWith("#")) continue;
                        int eq = line.indexOf('=');
                        if (eq > 0) {
                            String key   = line.substring(0, eq).trim();
                            String value = line.substring(eq + 1).trim();
                            ENV.put(key, value);
                        }
                    }
                    System.out.println("[DBUtil] Loaded .env from: " + envFile.getAbsolutePath());
                } catch (IOException e) {
                    System.err.println("[DBUtil] Warning: Could not read .env file: " + e.getMessage());
                }
                break; // Stop after first found .env
            }
        }
    }

    /**
     * Resolves a config value using priority order:
     *   1. .env file (local dev)
     *   2. OS environment variable (Render / Docker)
     *   3. Hardcoded default (fallback)
     */
    private static String resolve(String key, String defaultValue) {
        // 1. Check .env file first
        if (ENV.containsKey(key)) return ENV.get(key);
        // 2. Check OS environment variable (set by Render/Docker)
        String osEnv = System.getenv(key);
        if (osEnv != null && !osEnv.isEmpty()) return osEnv;
        // 3. Fall back to default
        return defaultValue;
    }

    /**
     * Obtains a connection to the MySQL database.
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * Safely closes one or more closeable resources (like Connection, Statement, ResultSet).
     * @param resources Varargs of AutoCloseable resources
     */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try {
                    r.close();
                } catch (Exception ignored) {
                    // Suppress exceptions during cleanup
                }
            }
        }
    }
}
