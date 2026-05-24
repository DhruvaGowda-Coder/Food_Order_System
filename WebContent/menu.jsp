<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.foodorder.model.MenuItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu | BiteBlitz</title>
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
        <h2 class="text-center">Our Delicious Menu</h2>
        
        <div class="menu-grid">
            <% 
                List<MenuItem> menuList = (List<MenuItem>) request.getAttribute("menuList");
                if (menuList != null && !menuList.isEmpty()) {
                    for (MenuItem item : menuList) { 
            %>
            <div class="menu-card">
                <h3><%= item.getItemName() %></h3>
                <div class="price">₹<%= String.format("%.2f", item.getPrice()) %></div>
                
                <form action="order" method="post" class="order-form">
                    <input type="hidden" name="itemId" value="<%= item.getId() %>">
                    <input type="number" name="quantity" min="1" value="1" required>
                    <button type="submit" class="btn btn-small">Order Now</button>
                </form>
            </div>
            <% 
                    }
                } else { 
            %>
            <p class="text-center">No menu items available. Admin needs to add items.</p>
            <% } %>
        </div>
    </div>
</body>
</html>
