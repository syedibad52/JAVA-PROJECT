package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    // Modify URL, USER, and PASSWORD to match your local MySQL configuration
    private static final String URL      = "jdbc:mysql://localhost:3306/course_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER     = "root";
    private static final String PASSWORD = "syedsyed"; // Updated password

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
