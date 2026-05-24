<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="com.foodorder.util.DBConnection" %>
<%
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("DELETE FROM orders")) {
         
        ps.executeUpdate();
        
    } catch(Exception e) {
        e.printStackTrace();
    }
    
    response.sendRedirect("history.jsp");
%>
