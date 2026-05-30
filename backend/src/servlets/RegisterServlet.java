package servlets;

import dao.StudentDAO;
import model.Student;
import util.ExcelExporter;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/register", "/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        // Validate basic input fields
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, res);
            return;
        }

        Student s = new Student();
        s.setName(name.trim());
        s.setEmail(email.trim());
        s.setPassword(password);

        StudentDAO dao = new StudentDAO();
        if (dao.register(s)) {
            // Auto-update the Excel file on Desktop with the new registration
            ExcelExporter.exportStudentRegistrations();
            // Registration success, redirect to login
            res.sendRedirect(req.getContextPath() + "/login?msg=registered");
        } else {
            // Registration failure (e.g. duplicate email)
            req.setAttribute("error", "Email already registered or registration failed.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, res);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Forward HTTP GET requests to the JSP registration view
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, res);
    }
}
