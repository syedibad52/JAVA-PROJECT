package servlets;

import dao.EnrollmentDAO;
import model.Student;
import util.ExcelExporter;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/student/enroll")
public class EnrollServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("student") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("student");
        String courseIdStr = req.getParameter("courseId");
        String actionStr   = req.getParameter("action");

        if (courseIdStr == null || actionStr == null) {
            res.sendRedirect(req.getContextPath() + "/student/courses?msg=failed");
            return;
        }

        int courseId = Integer.parseInt(courseIdStr);
        EnrollmentDAO dao = new EnrollmentDAO();
        String msg;

        if ("enroll".equals(actionStr)) {
            boolean success = dao.enroll(student.getId(), courseId);
            msg = success ? "success" : "failed";
            if (success) {
                // Auto-update the Excel file on Desktop with the new enrollment
                ExcelExporter.exportCourseEnrollments();
            }
        } else if ("drop".equals(actionStr)) {
            boolean success = dao.unenroll(student.getId(), courseId);
            msg = success ? "dropped" : "failed";
            if (success) {
                // Auto-update the Excel file on Desktop after dropping a course
                ExcelExporter.exportCourseEnrollments();
            }
        } else {
            msg = "failed";
        }

        res.sendRedirect(req.getContextPath() + "/student/courses?msg=" + msg);
    }
}
