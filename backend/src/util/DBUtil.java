package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String DEFAULT_URL  = "jdbc:mysql://localhost:3306/course_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "syedsyed"; // Updated password

    private static final String URL      = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : DEFAULT_URL;
    private static final String USER     = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : DEFAULT_USER;
    private static final String PASSWORD = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : DEFAULT_PASS;

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
