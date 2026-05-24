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
                    "price REAL NOT NULL, " +
                    "image_url TEXT)");
                    
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
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Classic Margherita Pizza', 250.00, 'images/pizza.png')");
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Spicy Paneer Burger', 120.00, 'images/burger.png')");
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Grilled Veg Sandwich', 90.00, 'images/sandwich.png')");
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Cold Coffee with Ice Cream', 110.00, 'images/coffee.png')");
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Peri Peri French Fries', 80.00, 'images/fries.png')");
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Hot Chocolate Fudge', 150.00, 'images/fudge.png')");
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Spicy Veg Hakka Noodles', 180.00, 'images/noodles.png')");
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Tandoori Paneer Momos', 130.00, 'images/momos.png')");
                
                // 4 new items requested by user
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Creamy Alfredo Pasta', 220.00, 'images/pasta.png')");
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Fresh Garden Salad', 140.00, 'images/salad.png')");
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Strawberry Milkshake', 120.00, 'images/milkshake.png')");
                stmt.executeUpdate("INSERT INTO menu (item_name, price, image_url) VALUES ('Mexican Veg Tacos', 160.00, 'images/tacos.png')");
                
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
