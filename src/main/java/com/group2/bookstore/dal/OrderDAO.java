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
    // Đã thêm tham số String receiverName vào hàm
    public void createOrder(User user, List<CartItem> cart, String receiverName, String shippingAddress, String phone, double total, String paymentMethod, int orderStatus) {
        
        // Đã sửa '1' thành '?' ở cột status
        String sqlOrder = "INSERT INTO Orders(user_id, order_date, total_amount, status, receiver_name, shipping_address, phone_number, payment_method) VALUES (?, GETDATE(), ?, ?, ?, ?, ?, ?)";
        Connection cn = null; 

        try {
            cn = getConnection();
            cn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Lưu Order
            PreparedStatement ps = cn.prepareStatement(sqlOrder, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, user.getId());
            ps.setDouble(2, total);
            ps.setInt(3, orderStatus);         // Truyền Trạng thái đơn hàng (Động)
            ps.setString(4, receiverName);     // Đã lùi index xuống 4
            ps.setString(5, shippingAddress);  // Đã lùi index xuống 5
            ps.setString(6, phone);            // Đã lùi index xuống 6
            ps.setString(7, paymentMethod);    // Đã lùi index xuống 7
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

            // ==============================================================
            // 3. TRỪ SỐ LƯỢNG TỒN KHO TRỰC TIẾP Ở ĐÂY (Reserve/Deduct Stock)
            // ==============================================================
            String sqlUpdateStock = "UPDATE Books SET stock_quantity = stock_quantity - ? WHERE book_id = ?";
            PreparedStatement psUpdateStock = cn.prepareStatement(sqlUpdateStock);
            for (CartItem item : cart) {
                psUpdateStock.setInt(1, item.getQuantity()); // Số lượng khách mua
                psUpdateStock.setInt(2, item.getBook().getId()); // ID sách
                psUpdateStock.addBatch();
            }
            psUpdateStock.executeBatch();

            // 4. Xóa giỏ hàng (CartItems)
            String sqlDeleteItems = "DELETE FROM CartItems WHERE cart_id = (SELECT cart_id FROM Cart WHERE user_id = ?)";
            PreparedStatement psDelItems = cn.prepareStatement(sqlDeleteItems);
            psDelItems.setInt(1, user.getId());
            psDelItems.executeUpdate();

            // 5. Xóa bảng Cart
            String sqlDeleteCart = "DELETE FROM Cart WHERE user_id = ?";
            PreparedStatement psDelCart = cn.prepareStatement(sqlDeleteCart);
            psDelCart.setInt(1, user.getId());
            psDelCart.executeUpdate();

            // TẤT CẢ OK -> LƯU VÀO DB
            cn.commit(); 
            
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback(); // CÓ LỖI -> HỦY BỎ TẤT CẢ (BAO GỒM CẢ VIỆC TRỪ KHO)
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (cn != null) {
                try {
                    cn.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
    }


    public List<Order> getOrdersByStatus(int status, String sortBy, String sortOrder) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.fullname, u.phone_number FROM Orders o " +
                     "JOIN Users u ON o.user_id = u.user_id " +
                     "WHERE o.status = ? ";
                     
        // Thêm logic sắp xếp theo tên khách hàng (fullname)
        if ("total".equals(sortBy)) {
            sql += "ORDER BY o.total_amount " + ("asc".equals(sortOrder) ? "ASC" : "DESC");
        } else if ("name".equals(sortBy)) {
            sql += "ORDER BY u.fullname " + ("asc".equals(sortOrder) ? "ASC" : "DESC");
        } else {
            sql += "ORDER BY o.order_date " + ("asc".equals(sortOrder) ? "ASC" : "DESC");
        }
        
        try (Connection cn = getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setInt(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getInt("status"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setUserName(rs.getString("fullname"));
                o.setPhoneNumber(rs.getString("phone_number"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateOrderStatus(int orderId, int newStatus) {
        String sqlUpdateStatus = "UPDATE Orders SET status = ? WHERE order_id = ?";
        
        // Câu lệnh SQL cộng trả lại sách vào kho (chỉ chạy khi status = 4)
        String sqlRollbackStock = "UPDATE b " +
                                  "SET b.stock_quantity = b.stock_quantity + od.quantity " +
                                  "FROM Books b " +
                                  "INNER JOIN OrderDetails od ON b.book_id = od.book_id " +
                                  "WHERE od.order_id = ?";
                                  
        Connection conn = null; 
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction để đảm bảo an toàn

            // 1. Cập nhật trạng thái đơn hàng
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateStatus)) {
                ps.setInt(1, newStatus);
                ps.setInt(2, orderId);
                int rows = ps.executeUpdate();
                System.out.println("Updated Order ID: " + orderId + " to Status: " + newStatus + " (Rows: " + rows + ")");
            }

            // 2. Kích hoạt Rollback Stock nếu Staff bấm Hủy (Trạng thái = 4)
            if (newStatus == 4) {
                try (PreparedStatement psStock = conn.prepareStatement(sqlRollbackStock)) {
                    psStock.setInt(1, orderId);
                    int stockRows = psStock.executeUpdate();
                    System.out.println("Rollback Stock for Order ID: " + orderId + " (Updated " + stockRows + " books)");
                }
            }

            conn.commit(); // Cả 2 lệnh đều thành công -> Lưu vào Database
            
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Có lỗi -> Hoàn tác tất cả, không cho sai lệch kho
                    System.out.println("Transaction rolled back for Order ID: " + orderId);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Trả lại trạng thái mặc định của hệ thống
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

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

    public int countOrdersByStatus(int userId, int status) {
        // Nếu status = -1 thì đếm TẤT CẢ đơn hàng của user đó
        String sql = "SELECT COUNT(*) FROM Orders WHERE user_id = ?";
        if (status != -1) {
            sql += " AND status = ?";
        }
        
        try (Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            if (status != -1) {
                ps.setInt(2, status);
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

                // CHANGED: Map username
                o.setUserName(rs.getString("username"));

                // CHANGED: Get phone from Order table column
                o.setPhoneNumber(rs.getString("phone_number"));

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Order> getAllOrdersBySale(String sortBy, String sortOrder) {
        List<Order> list = new ArrayList<>();
        // Join with Users table to get the Username
        String sql = "SELECT o.*, u.username FROM Orders o " +
                     "JOIN Users u ON o.user_id = u.user_id ";
        
        // Thêm logic sắp xếp theo tên khách hàng (username)
        if ("total".equals(sortBy)) {
            sql += "ORDER BY o.total_amount " + ("asc".equals(sortOrder) ? "ASC" : "DESC");
        } else if ("name".equals(sortBy)) {
            sql += "ORDER BY u.username " + ("asc".equals(sortOrder) ? "ASC" : "DESC");
        } else {
            sql += "ORDER BY o.order_date " + ("asc".equals(sortOrder) ? "ASC" : "DESC");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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

    // ==============================================================================
    // CÁC HÀM DÀNH RIÊNG CHO TRANG "ĐƠN HÀNG CỦA TÔI" (USER PROFILE)
    // ==============================================================================

    // Hàm phụ: Tự động nạp OrderDetails (Chi tiết sách) vào cho một Order
    private void loadDetailsForOrder(Order order, Connection conn) {
        String sql = "SELECT od.*, b.title, b.image FROM OrderDetails od "
                   + "JOIN Books b ON od.book_id = b.book_id "
                   + "WHERE od.order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, order.getId());
            try (ResultSet rs = ps.executeQuery()) {
                List<OrderDetail> details = new ArrayList<>();
                while (rs.next()) {
                    OrderDetail od = new OrderDetail();
                    od.setId(rs.getInt("order_detail_id")); // Đã khớp DB của bạn
                    od.setOrderId(rs.getInt("order_id"));
                    od.setBookId(rs.getInt("book_id"));
                    od.setQuantity(rs.getInt("quantity"));
                    od.setPrice(rs.getDouble("price"));

                    Book b = new Book();
                    b.setId(rs.getInt("book_id"));
                    b.setTitle(rs.getString("title"));
                    b.setImageUrl(rs.getString("image")); // Đã khớp DB của bạn
                    od.setBook(b);

                    details.add(od);
                }
                order.setDetails(details); 
            }
        } catch (Exception e) {
            System.out.println("Lỗi nạp sách cho Đơn hàng #" + order.getId() + ": " + e.getMessage());
        }
    }

    // 1. Lấy TẤT CẢ đơn hàng (Đã sửa lỗi xung đột Connection SQL Server)
    public List<Order> getAllOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE user_id = ? ORDER BY order_date DESC";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            // BƯỚC 1: Lấy hết "vỏ hộp" đơn hàng và đóng ResultSet lại
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("order_id"));
                    o.setUserId(rs.getInt("user_id"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setStatus(rs.getInt("status"));
                    list.add(o);
                }
            } // rs tự động được đóng ở đây!
            
            // BƯỚC 2: Đường truyền đã rảnh, giờ mới chạy vòng lặp nhét sách vào hộp
            for (Order o : list) {
                loadDetailsForOrder(o, conn); 
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy đơn hàng THEO TRẠNG THÁI (Đã sửa lỗi xung đột Connection SQL Server)
    public List<Order> getOrdersByStatusForUser(int userId, int status) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE user_id = ? AND status = ? ORDER BY order_date DESC";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, status);
            
            // BƯỚC 1: Lấy hết "vỏ hộp"
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("order_id"));
                    o.setUserId(rs.getInt("user_id"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setStatus(rs.getInt("status"));
                    list.add(o);
                }
            }
            
            // BƯỚC 2: Đường truyền rảnh, nhét sách vào
            for (Order o : list) {
                loadDetailsForOrder(o, conn); 
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
