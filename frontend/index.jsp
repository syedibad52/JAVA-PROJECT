<%-- frontend/index.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirect to the login servlet/page
    response.sendRedirect(request.getContextPath() + "/login");
%>
