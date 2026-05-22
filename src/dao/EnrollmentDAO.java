package dao;

import model.Enrollment;
import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EnrollmentDAO {

    /**
     * Enrolls a student in a course, checking capacity first.
     * Prevents duplicate enrollment and enrollment in full courses.
     */
    public boolean enroll(int studentId, int courseId) {
        // Query to calculate remaining seats in the course
        String checkSql = "SELECT capacity - (SELECT COUNT(*) FROM enrollments WHERE course_id=?) AS seats FROM courses WHERE id=?";
        
        try (Connection con = DBUtil.getConnection()) {
            // Check capacity
            try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
                checkPs.setInt(1, courseId);
                checkPs.setInt(2, courseId);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        int seatsLeft = rs.getInt("seats");
                        if (seatsLeft <= 0) {
                            return false; // No seats available
                        }
                    } else {
                        return false; // Course doesn't exist
                    }
                }
            }

            // Perform enrollment
            String enrollSql = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";
            try (PreparedStatement enrollPs = con.prepareStatement(enrollSql)) {
                enrollPs.setInt(1, studentId);
                enrollPs.setInt(2, courseId);
                return enrollPs.executeUpdate() > 0;
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            // Unique key violation: already enrolled in this course
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Drops a course registration for a student.
     */
    public boolean unenroll(int studentId, int courseId) {
        String sql = "DELETE FROM enrollments WHERE student_id=? AND course_id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves the enrollment list for a specific student, including course names.
     */
    public List<Enrollment> getEnrollmentsByStudent(int studentId) {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.*, c.course_name FROM enrollments e " +
                     "JOIN courses c ON e.course_id = c.id " +
                     "WHERE e.student_id = ? " +
                     "ORDER BY e.enrolled_at DESC";
        
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Enrollment en = new Enrollment();
                    en.setId(rs.getInt("id"));
                    en.setStudentId(rs.getInt("student_id"));
                    en.setCourseId(rs.getInt("course_id"));
                    en.setCourseName(rs.getString("course_name"));
                    en.setEnrolledAt(rs.getTimestamp("enrolled_at"));
                    list.add(en);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Administrative report: lists all enrollments, detailing student and course names.
     */
    public List<Enrollment> getFullReport() {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.*, s.name AS student_name, c.course_name FROM enrollments e " +
                     "JOIN students s ON e.student_id = s.id " +
                     "JOIN courses c ON e.course_id = c.id " +
                     "ORDER BY e.enrolled_at DESC";
        
        try (Connection con = DBUtil.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Enrollment en = new Enrollment();
                en.setId(rs.getInt("id"));
                en.setStudentId(rs.getInt("student_id"));
                en.setCourseId(rs.getInt("course_id"));
                en.setStudentName(rs.getString("student_name"));
                en.setCourseName(rs.getString("course_name"));
                en.setEnrolledAt(rs.getTimestamp("enrolled_at"));
                list.add(en);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
