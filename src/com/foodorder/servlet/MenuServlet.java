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

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MenuItem> menuList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM menu";
            var pstmt = conn.prepareStatement(sql);
            var rs = pstmt.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String itemName = rs.getString("item_name");
                double price = rs.getDouble("price");
                String imageUrl = rs.getString("image_url");

                menuList.add(new MenuItem(id, itemName, price, imageUrl));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("menuList", menuList);
        request.getRequestDispatcher("menu.jsp").forward(request, response);
    }
}
