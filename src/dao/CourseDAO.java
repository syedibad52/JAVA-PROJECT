package dao;

import model.Course;
import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    /**
     * Retrieves all courses ordered alphabetically by course name.
     */
    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses ORDER BY course_name";
        try (Connection con = DBUtil.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a specific course by its ID.
     */
    public Course getCourseById(int id) {
        String sql = "SELECT * FROM courses WHERE id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Inserts a new course record into the database.
     */
    public boolean addCourse(Course c) {
        String sql = "INSERT INTO courses (course_name, description, credits, capacity, instructor, schedule) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getCourseName());
            ps.setString(2, c.getDescription());
            ps.setInt(3, c.getCredits());
            ps.setInt(4, c.getCapacity());
            ps.setString(5, c.getInstructor());
            ps.setString(6, c.getSchedule());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates an existing course record in the database.
     */
    public boolean updateCourse(Course c) {
        String sql = "UPDATE courses SET course_name=?, description=?, credits=?, capacity=?, instructor=?, schedule=? WHERE id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getCourseName());
            ps.setString(2, c.getDescription());
            ps.setInt(3, c.getCredits());
            ps.setInt(4, c.getCapacity());
            ps.setString(5, c.getInstructor());
            ps.setString(6, c.getSchedule());
            ps.setInt(7, c.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a course by its ID.
     */
    public boolean deleteCourse(int id) {
        String sql = "DELETE FROM courses WHERE id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Gets the number of students enrolled in a specific course.
     */
    public int getEnrolledCount(int courseId) {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE course_id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Maps a ResultSet row to a Course object.
     */
    private Course mapRow(ResultSet rs) throws SQLException {
        return new Course(
            rs.getInt("id"),
            rs.getString("course_name"),
            rs.getString("description"),
            rs.getInt("credits"),
            rs.getInt("capacity"),
            rs.getString("instructor"),
            rs.getString("schedule")
        );
    }
}
