package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.CartItem;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.OrderDetail;
import com.group2.bookstore.model.User;

public class OrderDAO extends DBContext {

    // 1. GET ALL ORDERS (For Admin Dashboard List)
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        // Join with Users table to get the Username
        String sql = "SELECT o.*, u.username FROM Orders o "
                + "JOIN Users u ON o.user_id = u.user_id "
                + "ORDER BY o.order_date DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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
        String sql = "SELECT o.*, u.username FROM Orders o "
                + "JOIN Users u ON o.user_id = u.user_id "
                + "WHERE o.order_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        String sql = "SELECT od.*, b.title, b.image FROM OrderDetails od "
                + "JOIN Books b ON od.book_id = b.book_id "
                + "WHERE od.order_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetail od = new OrderDetail();
                od.setId(rs.getInt("order_detail_id"));
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Thêm vào OrderDAO.java
// File: OrderDAO.java (Đã sửa lỗi)
    public void createOrder(User user, List<CartItem> cart, String fullname, String address, String phone, double total, String paymentMethod) {
        // CÂU SQL CHUẨN: Có đúng 8 cột và 8 giá trị (trong đó có 6 dấu ?)
        String sqlOrder = "INSERT INTO Orders(user_id, order_date, total_amount, status, receiver_name, shipping_address, phone_number, payment_method) VALUES (?, GETDATE(), ?, 1, ?, ?, ?, ?)";
        
        Connection cn = null; 
        try {
            cn = getConnection();
            cn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Lưu Order
            PreparedStatement ps = cn.prepareStatement(sqlOrder, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, user.getId());
            ps.setDouble(2, total);
            ps.setString(3, fullname);      // Tên người nhận
            ps.setString(4, address);       // Địa chỉ
            ps.setString(5, phone);         // Số điện thoại
            ps.setString(6, paymentMethod); // Phương thức thanh toán
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int orderID = rs.next() ? rs.getInt(1) : 0;

            // 2. Lưu OrderDetails
            String sqlDetail = "INSERT INTO OrderDetails(order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement psDetail = cn.prepareStatement(sqlDetail);
            for (CartItem item : cart) {
                psDetail.setInt(1, orderID);
                psDetail.setInt(2, item.getBook().getId());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setDouble(4, item.getBook().getPrice());
                psDetail.addBatch();
            }
            psDetail.executeBatch();

            // 3. Xóa các món đã mua khỏi CartItems
            String sqlDeleteItems = "DELETE FROM CartItems WHERE cart_id = (SELECT cart_id FROM Cart WHERE user_id = ?)";
            PreparedStatement psDelItems = cn.prepareStatement(sqlDeleteItems);
            psDelItems.setInt(1, user.getId());
            psDelItems.executeUpdate();

            // 4. Xóa bảng Cart
            String sqlDeleteCart = "DELETE FROM Cart WHERE user_id = ?";
            PreparedStatement psDelCart = cn.prepareStatement(sqlDeleteCart);
            psDelCart.setInt(1, user.getId());
            psDelCart.executeUpdate();

            cn.commit(); // Hoàn tất Transaction
        } catch (Exception e) {
            if (cn != null) {
                try { cn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (cn != null) {
                try { cn.close(); } catch (Exception ex) { ex.printStackTrace(); }
            }
        }
    }


    public List<Order> getOrdersByStatus(int status, String sortBy, String sortOrder, String searchQuery) {
        List<Order> list = new ArrayList<>();
        String col = "order_date";
        if ("name".equals(sortBy)) col = "receiver_name"; // Đổi cột sắp xếp thành receiver_name
        if ("total".equals(sortBy)) col = "total_amount";
        String order = "asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";

        // Chỉ truy vấn trên bảng Orders, tìm kiếm theo receiver_name
        String sql = "SELECT * FROM Orders WHERE status = ? AND (receiver_name LIKE ? OR phone_number LIKE ?) ORDER BY " + col + " " + order;
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + searchQuery + "%";
            ps.setInt(1, status);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                
                // Lấy receiver_name gán vào biến userName để file JSP hiển thị đúng
                o.setUserName(rs.getString("receiver_name")); 
                
                o.setPhoneNumber(rs.getString("phone_number"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getInt("status"));
                list.add(o);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }
    // public void updateOrderStatus(int orderId, int newStatus) {
    //     String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";

    // Upgraded method to include the note!
    public void updateStatus(int orderId, int status, String note) {
        String sql = "UPDATE Orders SET status = ?, status_note = ? WHERE order_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, status);
            ps.setString(2, note);
            ps.setInt(3, orderId);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Order> getAllOrdersBySale(String sortBy, String sortOrder) {
        List<Order> list = new ArrayList<>();
        // Join with Users table to get the Username
        String sql = "SELECT o.*, u.username FROM Orders o "
                + "JOIN Users u ON o.user_id = u.user_id ";

        // Logic sắp xếp (Lọc theo cột và chiều mũi tên)
        if ("total".equals(sortBy)) {
            sql += "ORDER BY o.total_amount " + ("asc".equals(sortOrder) ? "ASC" : "DESC");
        } else if ("name".equals(sortBy)) {
            sql += "ORDER BY u.username " + ("asc".equals(sortOrder) ? "ASC" : "DESC");
        } else {
            sql += "ORDER BY o.order_date " + ("asc".equals(sortOrder) ? "ASC" : "DESC");
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setUserName(rs.getString("username"));
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

    // Add/Update these methods in your OrderDAO class
// 1. COUNT TOTAL ORDERS (For Pagination)
    public int countOrders(String keyword, String fromDate, String toDate, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Orders o ");
        sql.append("JOIN Users u ON o.user_id = u.user_id "); // Join to search by Customer Name
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // A. Keyword Search
        // --- FILTER LOGIC  ---
        if (keyword != null && !keyword.trim().isEmpty()) {
            String searchKey = keyword.trim();

            // SMART SEARCH LOGIC:
            // Case A: User typed "#" (e.g., "#2"). Strict search for ID only.
            if (searchKey.startsWith("#")) {
                searchKey = searchKey.replace("#", "").trim();

                // Use EXACT match for ID, and do not search Name/Phone
                sql.append(" AND o.order_id = ? ");

                // Try to parse as integer for safety, defaulting to -1 if invalid
                int searchId = -1;
                try {
                    searchId = Integer.parseInt(searchKey);
                } catch (NumberFormatException e) {
                    // If user typed "#abc", it won't match any ID
                }
                params.add(searchId);
            } // Case B: Normal search (ID, Name, or Phone) using LIKE
            else {
                sql.append(" AND (CAST(o.order_id AS VARCHAR) LIKE ? OR u.username LIKE ? OR o.phone_number LIKE ?) ");
                String key = "%" + searchKey + "%";
                params.add(key);
                params.add(key);
                params.add(key);
            }
        }

        // B. Date Range Filter
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND o.order_date >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND o.order_date <= ? ");
            params.add(toDate + " 23:59:59"); // Ensure we get the whole day
        }

        // C. Status Filter
        if (status != null && !status.equals("All Statuses") && !status.isEmpty()) {
            sql.append(" AND o.status = ? ");
            params.add(status);
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

// 2. GET ORDERS (Sorted & Paginated)
    public List<Order> getOrders(String keyword, String fromDate, String toDate, String status,
            String sortBy, String sortOrder, int index) {
        List<Order> list = new ArrayList<>();

        // CHANGED: Select u.username. Removed u.phone (we will use o.phone_number instead)
        StringBuilder sql = new StringBuilder("SELECT o.*, u.username FROM Orders o ");
        sql.append("JOIN Users u ON o.user_id = u.user_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // --- FILTER LOGIC (Replace your existing keyword block with this) ---
        if (keyword != null && !keyword.trim().isEmpty()) {
            String searchKey = keyword.trim();

            // SMART SEARCH LOGIC:
            // Case A: User typed "#" (e.g., "#2"). Strict search for ID only.
            if (searchKey.startsWith("#")) {
                searchKey = searchKey.replace("#", "").trim();

                // Use EXACT match for ID, and do not search Name/Phone
                sql.append(" AND o.order_id = ? ");

                // Try to parse as integer for safety, defaulting to -1 if invalid
                int searchId = -1;
                try {
                    searchId = Integer.parseInt(searchKey);
                } catch (NumberFormatException e) {
                    // If user typed "#abc", it won't match any ID
                }
                params.add(searchId);
            } // Case B: Normal search (ID, Name, or Phone) using LIKE
            else {
                sql.append(" AND (CAST(o.order_id AS VARCHAR) LIKE ? OR u.username LIKE ? OR o.phone_number LIKE ?) ");
                String key = "%" + searchKey + "%";
                params.add(key);
                params.add(key);
                params.add(key);
            }
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND o.order_date >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND o.order_date <= ? ");
            params.add(toDate + " 23:59:59");
        }

        if (status != null && !status.equals("All Statuses") && !status.isEmpty()) {
            sql.append(" AND o.status = ? ");
            // Map status string to int if necessary
            if (status.equals("Pending")) {
                params.add(1);
            } else if (status.equals("Shipping")) {
                params.add(2);
            } else if (status.equals("Completed")) {
                params.add(3);
            } else if (status.equals("Cancelled")) {
                params.add(0);
            } else {
                params.add(status);
            }
        }

        // --- SORTING ---
        if (sortBy != null && !sortBy.isEmpty()) {
            if (sortBy.equals("customer")) {
                sql.append(" ORDER BY u.username"); // Sort by username
            } else if (sortBy.equals("total_amount") || sortBy.equals("status") || sortBy.equals("order_id")) {
                sql.append(" ORDER BY o.").append(sortBy);
            } else if (sortBy.equals("order_date")) {
                sql.append(" ORDER BY o.order_date");
            } else {
                sql.append(" ORDER BY o.order_id");
            }

            if ("ASC".equalsIgnoreCase(sortOrder)) {
                sql.append(" ASC");
            } else {
                sql.append(" DESC");
            }
        } else {
            sql.append(" ORDER BY o.order_id DESC");
        }

        // --- PAGINATION ---
        sql.append(" OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY");
        params.add((index - 1) * 5);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getInt("status"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setUserName(rs.getString("username"));
                o.setPhoneNumber(rs.getString("phone_number"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Order> getAllOrdersBySale(String sortBy, String sortOrder, String searchQuery) {
        List<Order> list = new ArrayList<>();
        String col = "order_date";
        if ("name".equals(sortBy)) col = "receiver_name"; // Đổi cột sắp xếp thành receiver_name
        if ("total".equals(sortBy)) col = "total_amount";
        String order = "asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";

        // Chỉ truy vấn trên bảng Orders, tìm kiếm theo receiver_name
        String sql = "SELECT * FROM Orders WHERE (receiver_name LIKE ? OR phone_number LIKE ?) ORDER BY " + col + " " + order;
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + searchQuery + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                
                // Lấy receiver_name gán vào biến userName để file JSP hiển thị đúng
                o.setUserName(rs.getString("receiver_name")); 
                
                o.setPhoneNumber(rs.getString("phone_number"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getInt("status"));
                list.add(o);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }
    // Lấy thống kê doanh thu ngày hôm nay
    public double[] getTodaySummary() {
        // Mảng chứa 3 giá trị: [0] Tổng số đơn, [1] Đơn chờ xử lý, [2] Doanh thu (Đơn đã hoàn thành status = 3)
        double[] summary = new double[3];
        
        String sql = "SELECT " +
                     "COUNT(order_id) AS total_orders, " +
                     "SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS pending_orders, " +
                     "SUM(CASE WHEN status = 3 THEN total_amount ELSE 0 END) AS revenue " +
                     "FROM Orders " +
                     "WHERE CAST(order_date AS DATE) = CAST(GETDATE() AS DATE)";
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            if (rs.next()) {
                summary[0] = rs.getDouble("total_orders");
                summary[1] = rs.getDouble("pending_orders");
                summary[2] = rs.getDouble("revenue");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return summary;
    }
}
