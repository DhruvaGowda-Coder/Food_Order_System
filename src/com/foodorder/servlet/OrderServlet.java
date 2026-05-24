package com.foodorder.servlet;

import com.foodorder.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String itemIdStr = request.getParameter("itemId");
        String quantityStr = request.getParameter("quantity");
        
        if (itemIdStr == null || quantityStr == null) {
            response.sendRedirect("menu");
            return;
        }

        int itemId = Integer.parseInt(itemIdStr);
        int quantity = Integer.parseInt(quantityStr);
        double price = 0.0;
        String itemName = "";
        
        // Fetch item details
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT item_name, price FROM menu WHERE id=?")) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    itemName = rs.getString("item_name");
                    price = rs.getDouble("price");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        double subtotal = price * quantity;
        double gst = subtotal * 0.18;
        double total = subtotal + gst;
        
        // Save order
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO orders (item_name, quantity, total) VALUES (?, ?, ?)")) {
            ps.setString(1, itemName);
            ps.setInt(2, quantity);
            ps.setDouble(3, total);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Pass details to bill.jsp
        request.setAttribute("itemName", itemName);
        request.setAttribute("price", price);
        request.setAttribute("quantity", quantity);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("gst", gst);
        request.setAttribute("total", total);
        
        request.getRequestDispatcher("bill.jsp").forward(request, response);
    }
}
