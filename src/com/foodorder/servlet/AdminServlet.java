package com.foodorder.servlet;

import com.foodorder.model.MenuItem;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            deleteItem(request, response);
            return;
        }
        
        // List items
        List<MenuItem> menuList = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM menu");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                menuList.add(new MenuItem(rs.getInt("id"), rs.getString("item_name"), rs.getDouble("price")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("menuList", menuList);
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addItem(request, response);
        } else if ("update".equals(action)) {
            updateItem(request, response);
        } else {
            response.sendRedirect("admin");
        }
    }
    
    private void addItem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String itemName = request.getParameter("itemName");
        double price = Double.parseDouble(request.getParameter("price"));
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO menu (item_name, price) VALUES (?, ?)")) {
            ps.setString(1, itemName);
            ps.setDouble(2, price);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("admin");
    }
    
    private void updateItem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        double price = Double.parseDouble(request.getParameter("price"));
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE menu SET price=? WHERE id=?")) {
            ps.setDouble(1, price);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("admin");
    }
    
    private void deleteItem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM menu WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("admin");
    }
}
