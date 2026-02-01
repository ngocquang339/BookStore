package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.OrderDetail;

public class OrderDAO extends DBContext {

    // 1. GET ALL ORDERS (For Admin Dashboard List)
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        // Join with Users table to get the Username
        String sql = "SELECT o.*, u.username FROM Orders o " +
                     "JOIN Users u ON o.user_id = u.user_id " +
                     "ORDER BY o.order_date DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setUserName(rs.getString("username")); // Ensure your Order.java has this setter
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getInt("status"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setPhoneNumber(rs.getString("phone_number"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. GET ORDER BY ID (For Order Detail Page - Header Info)
    public Order getOrderById(int id) {
        String sql = "SELECT o.*, u.username FROM Orders o " +
                     "JOIN Users u ON o.user_id = u.user_id " +
                     "WHERE o.order_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setUserName(rs.getString("username"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getInt("status"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setPhoneNumber(rs.getString("phone_number"));
                return o;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. GET ORDER DETAILS (The list of books in a specific order)
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        // Join with Books to get Title and Image
        String sql = "SELECT od.*, b.title, b.image FROM OrderDetails od " +
                     "JOIN Books b ON od.book_id = b.book_id " +
                     "WHERE od.order_id = ?";
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                OrderDetail od = new OrderDetail();
                od.setId(rs.getInt("detail_id"));
                od.setOrderId(rs.getInt("order_id"));
                od.setBookId(rs.getInt("book_id"));
                od.setQuantity(rs.getInt("quantity"));
                od.setPrice(rs.getDouble("price"));
                
                // Create a temporary Book object to hold display info
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setImageUrl(rs.getString("image")); // Handles the image filename
                od.setBook(b); // Save it to the detail
                
                list.add(od);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. UPDATE ORDER STATUS (For Admin to 'Ship' or 'Cancel')
    public void updateStatus(int orderId, int status) {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}