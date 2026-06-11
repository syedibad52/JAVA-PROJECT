package dao;

import util.DBUtil;
import java.sql.*;

public class AdminDAO {

    /**
     * Ensures the admins table exists and contains the default admin account
     * with the correct password. Uses UPSERT to fix any corrupted passwords.
     */
    private void ensureDefaultAdmin() throws SQLException {
        String createTable = "CREATE TABLE IF NOT EXISTS admins ("
                + "id INT AUTO_INCREMENT PRIMARY KEY, "
                + "username VARCHAR(50) UNIQUE NOT NULL, "
                + "password VARCHAR(255) NOT NULL"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";

        // UPSERT: insert the default admin, or reset password if row already exists
        String upsertSql = "INSERT INTO admins (username, password) "
                + "VALUES ('admin', MD5('admin123')) "
                + "ON DUPLICATE KEY UPDATE password = MD5('admin123')";

        try (Connection con = DBUtil.getConnection()) {
            // Ensure table exists
            try (Statement st = con.createStatement()) {
                st.executeUpdate(createTable);
            }
            // Insert or update default admin
            try (Statement st = con.createStatement()) {
                int rows = st.executeUpdate(upsertSql);
                if (rows > 0) {
                    System.out.println("[AdminDAO] Default admin account ensured (admin / admin123)");
                }
            }
        }
    }

    /**
     * Authenticates an admin using username and password.
     * Password is encrypted using MD5 to match the database values.
     * Automatically seeds/fixes the default admin before authentication.
     */
    public boolean authenticate(String username, String password) throws SQLException {
        // Ensure the default admin exists with the correct password
        ensureDefaultAdmin();

        String sql = "SELECT * FROM admins WHERE username=? AND password=MD5(?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                boolean matched = rs.next();
                if (!matched) {
                    System.err.println("[AdminDAO] Auth failed for username: " + username);
                }
                return matched;
            }
        }
    }
}

