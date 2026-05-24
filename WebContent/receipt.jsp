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
    <title>Receipt | BiteBlitz</title>
    <style>
        body { font-family: 'Courier New', Courier, monospace; margin: 0; padding: 20px; background-color: #f4f4f4; }
        .receipt-container { max-width: 400px; margin: 0 auto; background: #fff; padding: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .header { text-align: center; border-bottom: 2px dashed #000; padding-bottom: 20px; margin-bottom: 20px; }
        .header h1 { margin: 0; font-size: 24px; text-transform: uppercase; }
        .header p { margin: 5px 0 0; color: #555; }
        .details { margin-bottom: 20px; }
        .details p { margin: 5px 0; }
        .items { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .items th, .items td { padding: 10px 0; text-align: left; border-bottom: 1px dashed #ccc; }
        .items th { text-transform: uppercase; font-size: 14px; }
        .items td:last-child, .items th:last-child { text-align: right; }
        .totals { border-top: 2px dashed #000; padding-top: 20px; margin-top: 20px; }
        .totals div { display: flex; justify-content: space-between; margin-bottom: 10px; font-weight: bold; font-size: 16px; }
        .totals .grand-total { font-size: 20px; text-transform: uppercase; }
        .footer { text-align: center; margin-top: 40px; font-size: 14px; color: #555; border-top: 2px dashed #000; padding-top: 20px; }
        
        @media print {
            body { background: none; }
            .receipt-container { box-shadow: none; max-width: 100%; margin: 0; padding: 0; }
        }
    </style>
</head>
<body>
    <div class="receipt-container">
        <% 
            String orderIdStr = request.getParameter("id");
            if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("SELECT * FROM orders WHERE order_id = ?")) {
                     
                    ps.setInt(1, Integer.parseInt(orderIdStr));
                    ResultSet rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        String itemName = rs.getString("item_name");
                        int quantity = rs.getInt("quantity");
                        double total = rs.getDouble("total");
                        java.sql.Timestamp date = rs.getTimestamp("order_date");
                        
                        double pricePerItem = total / 1.05 / quantity; // Extracting original price minus 5% GST
                        double subtotal = pricePerItem * quantity;
                        double gst = subtotal * 0.05;
        %>
        
        <div class="header">
            <h1>BiteBlitz.</h1>
            <p>123 Foodie Lane, Flavor Town</p>
            <p>Phone: +91 98765 43210</p>
        </div>
        
        <div class="details">
            <p><strong>Order No:</strong> #<%= rs.getInt("order_id") %></p>
            <p><strong>Date:</strong> <%= date %></p>
            <p><strong>Customer:</strong> Guest</p>
        </div>
        
        <table class="items">
            <thead>
                <tr>
                    <th>Item</th>
                    <th>Qty</th>
                    <th>Price</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= itemName %></td>
                    <td><%= quantity %></td>
                    <td>₹<%= String.format("%.2f", subtotal) %></td>
                </tr>
            </tbody>
        </table>
        
        <div class="totals">
            <div>
                <span>Subtotal:</span>
                <span>₹<%= String.format("%.2f", subtotal) %></span>
            </div>
            <div>
                <span>Taxes (GST 5%):</span>
                <span>₹<%= String.format("%.2f", gst) %></span>
            </div>
            <div class="grand-total">
                <span>Total Amount:</span>
                <span>₹<%= String.format("%.2f", total) %></span>
            </div>
        </div>
        
        <div class="footer">
            <p>Thank you for ordering with BiteBlitz!</p>
            <p>Please come again.</p>
        </div>
        
        <%
                    } else {
                        out.println("<h3 style='text-align:center;'>Order not found.</h3>");
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                    out.println("<p>Error generating receipt.</p>");
                }
            } else {
                out.println("<h3 style='text-align:center;'>Invalid Order ID.</h3>");
            }
        %>
    </div>
    
    <script>
        // Trigger print dialog automatically when the page loads
        window.onload = function() {
            window.print();
        }
    </script>
</body>
</html>
