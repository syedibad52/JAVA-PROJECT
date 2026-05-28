package servlets.admin;

import dao.EnrollmentDAO;
import model.Enrollment;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/export-enrollments")
public class ExportEnrollmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // 1. Session verification (only admins can export data)
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Fetch the latest enrollment report data
        EnrollmentDAO enrollDAO = new EnrollmentDAO();
        List<Enrollment> report = enrollDAO.getFullReport();

        // 3. Set content type and headers to download as CSV (natively opens in Excel)
        res.setContentType("text/csv; charset=UTF-8");
        res.setHeader("Content-Disposition", "attachment; filename=\"realtime_enrollments.csv\"");

        // 4. Write CSV contents
        try (PrintWriter writer = res.getWriter()) {
            // Write UTF-8 BOM for perfect compatibility with MS Excel
            writer.write('\ufeff');

            // Write CSV Header Row
            writer.println("Index,Student Name,Course Name,Registration Timestamp");

            if (report != null) {
                int index = 1;
                for (Enrollment e : report) {
                    String studentName = escapeCsv(e.getStudentName());
                    String courseName = escapeCsv(e.getCourseName());
                    String enrolledAt = escapeCsv(String.valueOf(e.getEnrolledAt()));
                    
                    writer.println(index++ + "," + studentName + "," + courseName + "," + enrolledAt);
                }
            }
        }
    }

    /**
     * Helper method to escape special characters for CSV format.
     */
    private String escapeCsv(String value) {
        if (value == null) {
            return "";
        }
        if (value.contains(",") || value.contains("\"") || value.contains("\n") || value.contains("\r")) {
            value = value.replace("\"", "\"\"");
            return "\"" + value + "\"";
        }
        return value;
    }
}
