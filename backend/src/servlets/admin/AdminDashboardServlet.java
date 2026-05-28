package servlets.admin;

import dao.CourseDAO;
import dao.EnrollmentDAO;
import dao.StudentDAO;
import model.Course;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        CourseDAO courseDAO = new CourseDAO();
        StudentDAO studentDAO = new StudentDAO();
        EnrollmentDAO enrollDAO = new EnrollmentDAO();

        // Bind data for stats, management, and report generation
        req.setAttribute("courses", courseDAO.getAllCourses());
        req.setAttribute("students", studentDAO.getAllStudents());
        req.setAttribute("report", enrollDAO.getFullReport());

        // Forward to the admin panel JSP
        req.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        CourseDAO courseDAO = new CourseDAO();

        if ("addCourse".equals(action)) {
            String courseName = req.getParameter("courseName");
            String description = req.getParameter("description");
            String creditsStr = req.getParameter("credits");
            String capacityStr = req.getParameter("capacity");
            String instructor = req.getParameter("instructor");
            String schedule = req.getParameter("schedule");

            // Simple validation
            if (courseName != null && !courseName.trim().isEmpty()) {
                Course c = new Course();
                c.setCourseName(courseName.trim());
                c.setDescription(description != null ? description.trim() : "");
                c.setCredits(creditsStr != null ? Integer.parseInt(creditsStr) : 3);
                c.setCapacity(capacityStr != null ? Integer.parseInt(capacityStr) : 30);
                c.setInstructor(instructor != null ? instructor.trim() : "TBD");
                c.setSchedule(schedule != null ? schedule.trim() : "TBD");
                courseDAO.addCourse(c);
            }
        } else if ("deleteCourse".equals(action)) {
            String courseIdStr = req.getParameter("courseId");
            if (courseIdStr != null) {
                int courseId = Integer.parseInt(courseIdStr);
                courseDAO.deleteCourse(courseId);
            }
        } else if ("deleteStudent".equals(action)) {
            String studentIdStr = req.getParameter("studentId");
            if (studentIdStr != null) {
                int studentId = Integer.parseInt(studentIdStr);
                new StudentDAO().deleteStudent(studentId);
            }
        }

        // Redirect back to dashboard to refresh data and avoid form re-submission on
        // reload
        res.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
