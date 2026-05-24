<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.foodorder.model.MenuItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | BiteBlitz</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;800&family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <nav>
            <a href="index.jsp" class="logo">Bite<span>Blitz.</span> <span style="font-weight:400; font-size:1.2rem; margin-left:0.5rem; opacity:0.8; -webkit-text-fill-color: var(--secondary); background: none;">Admin</span></a>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="menu">Menu</a></li>
                <li><a href="history.jsp">Order History</a></li>
                <li class="active"><a href="admin">Admin</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h2 class="text-center">Menu Management</h2>
        
        <div class="admin-actions">
            <h3>Add New Item</h3>
            <form action="admin" method="post" enctype="multipart/form-data" class="admin-form">
                <input type="hidden" name="action" value="add">
                <input type="text" name="itemName" placeholder="Item Name" required>
                <input type="number" name="price" step="0.01" placeholder="Price (₹)" required>
                <input type="file" name="image" accept="image/*">
                <button type="submit" class="btn btn-small">Add Item</button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Item Name</th>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% 
                List<MenuItem> menuList = (List<MenuItem>) request.getAttribute("menuList");
                if (menuList != null && !menuList.isEmpty()) {
                    for (MenuItem item : menuList) { 
            %>
                <tr>
                    <td><%= item.getId() %></td>
                    <td><%= item.getItemName() %></td>
                    <td>
                        <form action="admin" method="post" style="display:inline-flex; gap: 0.5rem; align-items:center;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%= item.getId() %>">
                            ₹ <input type="number" name="price" step="0.01" value="<%= item.getPrice() %>" style="width:80px; padding:0.2rem;" required>
                            <button type="submit" class="btn btn-small" style="padding:0.3rem 0.6rem;">Update</button>
                        </form>
                    </td>
                    <td>
                        <a href="admin?action=delete&id=<%= item.getId() %>" class="btn btn-small btn-danger" onclick="return confirm('Are you sure you want to delete this item?');">Delete</a>
                    </td>
                </tr>
            <% 
                    }
                } else { 
            %>
                <tr>
                    <td colspan="4" class="text-center">No menu items found.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
