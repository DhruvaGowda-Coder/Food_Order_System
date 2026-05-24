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
    <title>Total Receipt | BiteBlitz</title>
    <style>
        body { font-family: 'Courier New', Courier, monospace; margin: 0; padding: 20px; background-color: #f4f4f4; }
        .receipt-container { max-width: 500px; margin: 0 auto; background: #fff; padding: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
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
        <div class="header">
            <h1>BiteBlitz.</h1>
            <p>123 Foodie Lane, Flavor Town</p>
            <p>Phone: +91 98765 43210</p>
            <p><strong>CONSOLIDATED STATEMENT</strong></p>
        </div>
        
        <div class="details">
            <p><strong>Date Generated:</strong> <%= new java.util.Date() %></p>
            <p><strong>Customer:</strong> Guest</p>
        </div>
        
        <table class="items">
            <thead>
                <tr>
                    <th>Order #</th>
                    <th>Item</th>
                    <th>Qty</th>
                    <th>Total Price</th>
                </tr>
            </thead>
            <tbody>
        <% 
            double grandTotal = 0.0;
            double totalGst = 0.0;
            double totalSubtotal = 0.0;

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM orders ORDER BY order_date ASC");
                 ResultSet rs = ps.executeQuery()) {
                 
                boolean hasOrders = false;
                while (rs.next()) {
                    hasOrders = true;
                    int orderId = rs.getInt("order_id");
                    String itemName = rs.getString("item_name");
                    int quantity = rs.getInt("quantity");
                    double total = rs.getDouble("total");
                    
                    double subtotal = total / 1.05;
                    double gst = total - subtotal;
                    
                    grandTotal += total;
                    totalGst += gst;
                    totalSubtotal += subtotal;
        %>
                <tr>
                    <td>#<%= orderId %></td>
                    <td><%= itemName %></td>
                    <td><%= quantity %></td>
                    <td>₹<%= String.format("%.2f", total) %></td>
                </tr>
        <%
                }
                
                if (!hasOrders) {
                    out.println("<tr><td colspan='4' style='text-align:center;'>No orders found.</td></tr>");
                }
            } catch(Exception e) {
                e.printStackTrace();
                out.println("<tr><td colspan='4'>Error loading orders.</td></tr>");
            }
        %>
            </tbody>
        </table>
        
        <div class="totals">
            <div>
                <span>Total Subtotal:</span>
                <span>₹<%= String.format("%.2f", totalSubtotal) %></span>
            </div>
            <div>
                <span>Total Taxes (GST 5%):</span>
                <span>₹<%= String.format("%.2f", totalGst) %></span>
            </div>
            <div class="grand-total">
                <span>Total Amount:</span>
                <span>₹<%= String.format("%.2f", grandTotal) %></span>
            </div>
        </div>
        
        <div class="footer">
            <p>Thank you for ordering with BiteBlitz!</p>
            <p>Please come again.</p>
        </div>
    </div>
    
    <script>
        // Trigger print dialog automatically when the page loads
        window.onload = function() {
            window.print();
        }
    </script>
</body>
</html>
