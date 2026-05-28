package dao;

import util.DBUtil;
import java.sql.*;

public class AdminDAO {

    /**
     * Authenticates an admin using username and password.
     * Password is encrypted using MD5 to match the database values.
     */
    public boolean authenticate(String username, String password) {
        String sql = "SELECT * FROM admins WHERE username=? AND password=MD5(?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // If a record matches, authentication is successful
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
