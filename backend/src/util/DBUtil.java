package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    // Read database config from environment variables (for cloud deployment),
    // falling back to local defaults for development
    private static final String URL      = getEnvOrDefault("DB_URL",      "jdbc:mysql://localhost:3306/course_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
    private static final String USER     = getEnvOrDefault("DB_USER",     "root");
    private static final String PASSWORD = getEnvOrDefault("DB_PASSWORD", "syedsyed");

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }

    static {
        try {
            // Load the MySQL JDBC Driver class
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found! Ensure mysql-connector-j jar is in the classpath.", e);
        }
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
