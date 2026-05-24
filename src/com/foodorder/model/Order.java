package com.foodorder.model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private String itemName;
    private int quantity;
    private double total;
    private Timestamp orderDate;

    public Order(int orderId, String itemName, int quantity, double total, Timestamp orderDate) {
        this.orderId = orderId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.total = total;
        this.orderDate = orderDate;
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
}
