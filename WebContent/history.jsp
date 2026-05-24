<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.foodorder.util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History | BiteBlitz</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <nav>
            <a href="index.jsp" class="logo">BiteBlitz.</a>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="menu">Menu</a></li>
                <li><a href="history.jsp">Order History</a></li>
                <li><a href="admin">Admin</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h2 class="text-center">Your Order History</h2>
        
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Item Name</th>
                    <th>Quantity</th>
                    <th>Total Amount</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
            <% 
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("SELECT * FROM orders ORDER BY order_date DESC");
                     ResultSet rs = ps.executeQuery()) {
                     
                    boolean hasOrders = false;
                    while (rs.next()) {
                        hasOrders = true;
            %>
                <tr>
                    <td>#<%= rs.getInt("order_id") %></td>
                    <td><%= rs.getString("item_name") %></td>
                    <td><%= rs.getInt("quantity") %></td>
                    <td style="color: var(--primary); font-weight: bold;">₹<%= String.format("%.2f", rs.getDouble("total")) %></td>
                    <td><%= rs.getTimestamp("order_date") %></td>
                </tr>
            <% 
                    }
                    if (!hasOrders) {
            %>
                <tr>
                    <td colspan="5" class="text-center">No orders found.</td>
                </tr>
            <%
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                }
            %>
            </tbody>
        </table>
    </div>
</body>
</html>
