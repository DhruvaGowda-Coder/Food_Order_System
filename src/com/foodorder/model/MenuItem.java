package com.foodorder.model;

public class MenuItem {
    private int id;
    private String itemName;
    private double price;
    private String imageUrl;

    public MenuItem(int id, String itemName, double price, String imageUrl) {
        this.id = id;
        this.itemName = itemName;
        this.price = price;
        this.imageUrl = imageUrl;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
