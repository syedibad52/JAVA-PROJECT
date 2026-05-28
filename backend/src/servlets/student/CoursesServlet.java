package servlets.student;

import dao.CourseDAO;
import dao.EnrollmentDAO;
import model.Course;
import model.Enrollment;
import model.Student;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/student/courses")
public class CoursesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("student") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("student");
        CourseDAO courseDAO = new CourseDAO();
        EnrollmentDAO enrollDAO = new EnrollmentDAO();

        // Retrieve all available courses
        List<Course> allCourses = courseDAO.getAllCourses();
        // Retrieve courses the student is already enrolled in
        List<Enrollment> myEnrollments = enrollDAO.getEnrollmentsByStudent(student.getId());

        // Store enrolled course IDs in a set for quick lookup in JSP
        Set<Integer> enrolledIds = new HashSet<>();
        for (Enrollment e : myEnrollments) {
            enrolledIds.add(e.getCourseId());
        }

        // Pass lists as request attributes
        req.setAttribute("courses", allCourses);
        req.setAttribute("enrolledIds", enrolledIds);
        req.setAttribute("myEnrollments", myEnrollments);

        // Forward to the student JSP view
        req.getRequestDispatcher("/jsp/student/courses.jsp").forward(req, res);
    }
}
