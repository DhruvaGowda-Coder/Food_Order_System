<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill | BiteBlitz</title>
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
        <div class="bill-container">
            <h2 class="text-center" style="margin-bottom: 2rem;">Order Successful!</h2>
            
            <div class="bill-row">
                <span>Item Name:</span>
                <strong><%= request.getAttribute("itemName") %></strong>
            </div>
            
            <div class="bill-row">
                <span>Quantity:</span>
                <strong><%= request.getAttribute("quantity") %></strong>
            </div>
            
            <div class="bill-row">
                <span>Price per item:</span>
                <strong>₹<%= String.format("%.2f", request.getAttribute("price")) %></strong>
            </div>
            
            <div class="bill-row">
                <span>Subtotal:</span>
                <strong>₹<%= String.format("%.2f", request.getAttribute("subtotal")) %></strong>
            </div>
            
            <div class="bill-row">
                <span>GST (18%):</span>
                <strong>₹<%= String.format("%.2f", request.getAttribute("gst")) %></strong>
            </div>
            
            <div class="bill-row bill-total">
                <span>Final Total:</span>
                <span>₹<%= String.format("%.2f", request.getAttribute("total")) %></span>
            </div>
            
            <div class="text-center mt-2">
                <a href="menu" class="btn">Order More</a>
            </div>
        </div>
    </div>
</body>
</html>
