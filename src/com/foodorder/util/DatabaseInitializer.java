package com.foodorder.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.Statement;

@WebListener
public class DatabaseInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Create menu table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS menu (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "item_name TEXT NOT NULL, " +
                    "price REAL NOT NULL)");
                    
            // Create orders table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS orders (" +
                    "order_id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "item_name TEXT NOT NULL, " +
                    "quantity INTEGER NOT NULL, " +
                    "total REAL NOT NULL, " +
                    "order_date DATETIME DEFAULT CURRENT_TIMESTAMP)");
            
            // Check if menu is empty, if so, seed dummy data
            var rs = stmt.executeQuery("SELECT COUNT(*) AS count FROM menu");
            if (rs.next() && rs.getInt("count") == 0) {
                stmt.executeUpdate("INSERT INTO menu (item_name, price) VALUES ('Classic Margherita Pizza', 250.00)");
                stmt.executeUpdate("INSERT INTO menu (item_name, price) VALUES ('Spicy Paneer Burger', 120.00)");
                stmt.executeUpdate("INSERT INTO menu (item_name, price) VALUES ('Grilled Veg Sandwich', 90.00)");
                stmt.executeUpdate("INSERT INTO menu (item_name, price) VALUES ('Cold Coffee with Ice Cream', 110.00)");
                stmt.executeUpdate("INSERT INTO menu (item_name, price) VALUES ('Peri Peri French Fries', 80.00)");
                stmt.executeUpdate("INSERT INTO menu (item_name, price) VALUES ('Hot Chocolate Fudge', 150.00)");
                System.out.println("Database tables created and dummy data seeded successfully.");
            } else {
                System.out.println("Database already contains data.");
            }
            
        } catch (Exception e) {
            System.err.println("Database Initialization Failed!");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if necessary
    }
}
