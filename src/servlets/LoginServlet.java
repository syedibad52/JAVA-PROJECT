package servlets;

import dao.StudentDAO;
import dao.AdminDAO;
import model.Student;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String emailOrUser = req.getParameter("email");
        String password    = req.getParameter("password");
        String role        = req.getParameter("role");

        HttpSession session = req.getSession();

        if ("admin".equals(role)) {
            AdminDAO adminDAO = new AdminDAO();
            // Validate admin credentials against MySQL database table
            if (adminDAO.authenticate(emailOrUser, password)) {
                session.setAttribute("admin", emailOrUser);
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                req.setAttribute("error", "Invalid admin credentials");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
            }
        } else {
            StudentDAO studentDAO = new StudentDAO();
            // Validate student credentials using MD5 hash comparison
            Student student = studentDAO.authenticate(emailOrUser, password);
            if (student != null) {
                session.setAttribute("student", student);
                res.sendRedirect(req.getContextPath() + "/student/courses");
            } else {
                req.setAttribute("error", "Invalid email or password");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Forward HTTP GET requests to the JSP login view
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, res);
    }
}
