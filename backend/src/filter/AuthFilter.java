package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    // Paths that can be accessed without logging in
    private static final String[] PUBLIC_PATHS = {
            "/login",
            "/register",
            "/css/",
            "/images/",
            "/LoginServlet",
            "/RegisterServlet",
            "/index.jsp",
            "/jsp/login.jsp",
            "/jsp/register.jsp",
            "/jsp/error.jsp"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getServletPath();

        // 1. Allow access if it matches any public path
        for (String p : PUBLIC_PATHS) {
            if (path.startsWith(p) || path.equals("/")) {
                chain.doFilter(req, res);
                return;
            }
        }

        // 2. Check if a user is logged in (either Student or Admin)
        HttpSession session = request.getSession(false);
        boolean loggedIn = (session != null) &&
                (session.getAttribute("student") != null || session.getAttribute("admin") != null);

        // 3. Redirect to login if not authenticated, otherwise proceed
        if (!loggedIn) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            chain.doFilter(req, res);
        }
    }

    @Override
    public void destroy() {
    }
}
