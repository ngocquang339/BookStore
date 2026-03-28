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

                // ==============================================================
                // [MỚI THÊM] - Lấy thông tin Voucher và số tiền giảm giá
                // ==============================================================

                // Lấy ID Voucher (Nếu trong SQL là NULL thì rs.getInt() sẽ tự động trả về số 0)
                o.setVoucher_id(rs.getInt("voucher_id"));

                // Lấy số tiền giảm (Xử lý an toàn với BigDecimal)
                java.math.BigDecimal dbDiscount = rs.getBigDecimal("discount_amount");
                if (dbDiscount == null) {
                    o.setDiscountAmount(java.math.BigDecimal.ZERO); // Nếu không xài mã, mặc định là 0
                } else {
                    o.setDiscountAmount(dbDiscount); // Nếu có xài mã, gán số tiền vào
                }
                // ==============================================================

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
                o.setStaffNote(rs.getString("status_note")); // Lộc thêm
                
                // ==============================================================
                // [MỚI THÊM] - Lấy thông tin Voucher và số tiền giảm giá
                // ==============================================================
                o.setVoucher_id(rs.getInt("voucher_id"));

                java.math.BigDecimal dbDiscount = rs.getBigDecimal("discount_amount");
                if (dbDiscount == null) {
                    o.setDiscountAmount(java.math.BigDecimal.ZERO); // Mặc định là 0 nếu không xài mã
                } else {
                    o.setDiscountAmount(dbDiscount);
                }
                // ==============================================================

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

    // =========================================================================
    // 1. HÀM TẠO ĐƠN HÀNG (PHIÊN BẢN CỦA BẠN - CÓ VOUCHER & TRỪ KHO)
    // =========================================================================
    // =========================================================================
    // MASTER CREATE ORDER METHOD (Unified Teammate + Your Advanced Logic)
    // =========================================================================
    public int createOrder(User user, List<CartItem> cart, String receiverName, String shippingAddress, String phone, double total, String paymentMethod, int orderStatus, int voucherId, java.math.BigDecimal discountAmount,double shippingFee) {
        String sqlOrder = "INSERT INTO Orders(user_id, order_date, total_amount, status, receiver_name, shipping_address, phone_number, payment_method, voucher_id, discount_amount, shipping_fee) VALUES (?, GETDATE(), ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection cn = null; 
        int generatedOrderId = 0; 
        
        try {
            cn = getConnection();
            cn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Lưu Order (Header)
            PreparedStatement ps = cn.prepareStatement(sqlOrder, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, user.getId());
            ps.setDouble(2, total);
            ps.setInt(3, orderStatus);         
            ps.setString(4, receiverName);     
            ps.setString(5, shippingAddress);  
            ps.setString(6, phone);            
            ps.setString(7, paymentMethod);    
            
            // Xử lý an toàn cho Voucher & Discount (Cho phép NULL/0 nếu không dùng)
            if (voucherId > 0) {
                ps.setInt(8, voucherId);
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            if (discountAmount == null) {
                ps.setBigDecimal(9, java.math.BigDecimal.ZERO);
            } else {
                ps.setBigDecimal(9, discountAmount);
            }
            ps.setDouble(10, shippingFee);
            
            ps.executeUpdate();

            // Lấy ID vừa tạo
            ResultSet rs = ps.getGeneratedKeys();
            generatedOrderId = rs.next() ? rs.getInt(1) : 0;

            // 2. Lưu OrderDetails và Trừ Kho (Gộp chung vòng lặp cho tối ưu)
            String sqlDetail = "INSERT INTO OrderDetails(order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
            String sqlUpdateStock = "UPDATE Books SET stock_quantity = stock_quantity - ? WHERE book_id = ?";
            
            PreparedStatement psDetail = cn.prepareStatement(sqlDetail);
            PreparedStatement psUpdateStock = cn.prepareStatement(sqlUpdateStock);
            
            for (CartItem item : cart) {
                // Thêm vào batch Chi tiết đơn hàng
                psDetail.setInt(1, generatedOrderId);
                psDetail.setInt(2, item.getBook().getId());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setDouble(4, item.getBook().getPrice());
                psDetail.addBatch();
                
                // Thêm vào batch Trừ kho
                psUpdateStock.setInt(1, item.getQuantity()); 
                psUpdateStock.setInt(2, item.getBook().getId()); 
                psUpdateStock.addBatch();
            }
            psDetail.executeBatch();
            psUpdateStock.executeBatch();

            // 3. Xóa giỏ hàng (Cart & CartItems)
            String sqlDeleteItems = "DELETE FROM CartItems WHERE cart_id = (SELECT cart_id FROM Cart WHERE user_id = ?)";
            PreparedStatement psDelItems = cn.prepareStatement(sqlDeleteItems);
            psDelItems.setInt(1, user.getId());
            psDelItems.executeUpdate();

            String sqlDeleteCart = "DELETE FROM Cart WHERE user_id = ?";
            PreparedStatement psDelCart = cn.prepareStatement(sqlDeleteCart);
            psDelCart.setInt(1, user.getId());
            psDelCart.executeUpdate();

            cn.commit(); // TẤT CẢ THÀNH CÔNG -> CHỐT LƯU VÀO DB
            
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback(); // CÓ LỖI -> HỦY BỎ TOÀN BỘ QUÁ TRÌNH
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
        
        return generatedOrderId; 
    }

    // =========================================================================
    // 3. LẤY ĐƠN HÀNG THEO TRẠNG THÁI (PHIÊN BẢN 3 THAM SỐ CỦA BẠN)
    // =========================================================================
    public List<Order> getOrdersByStatus(int status, String sortBy, String sortOrder) {
        // Gọi thẳng vào hàm 4 tham số bên dưới bằng cách truyền searchQuery rỗng để tái sử dụng code
        return getOrdersByStatus(status, sortBy, sortOrder, "");
    }

    // =========================================================================
    // 4. LẤY ĐƠN HÀNG THEO TRẠNG THÁI (PHIÊN BẢN 4 THAM SỐ CỦA ĐỒNG ĐỘI)
    // =========================================================================
    public List<Order> getOrdersByStatus(int status, String sortBy, String sortOrder, String searchQuery) {
        List<Order> list = new ArrayList<>();
        String col = "order_date";
        if ("name".equals(sortBy))
            col = "receiver_name";
        if ("total".equals(sortBy))
            col = "total_amount";
        String order = "asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";

        String sql = "SELECT * FROM Orders WHERE status = ? AND (receiver_name LIKE ? OR phone_number LIKE ?) ORDER BY "
                + col + " " + order;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + (searchQuery == null ? "" : searchQuery) + "%";
            ps.setInt(1, status);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
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
    // String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";

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

    // =========================================================================
    // 6. CẬP NHẬT TRẠNG THÁI CÓ CHECK KHO (PHIÊN BẢN XỊN CỦA BẠN - TRẢ VỀ BOOLEAN)
    // =========================================================================
    public boolean updateOrderStatus(int orderId, int newStatus) {
        Connection conn = null;
        try {
        System.out.println(">>> Đang chạy updateOrderStatus cho Đơn " + orderId + " -> Status mới: " + newStatus);
        
        conn = getConnection();
        conn.setAutoCommit(false);

        int currentStatus = -1;
        String sqlCheck = "SELECT status FROM Orders WHERE order_id = ?";
        try (PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
            psCheck.setInt(1, orderId);
            ResultSet rs = psCheck.executeQuery();
            if (rs.next()) {
                currentStatus = rs.getInt("status");
                System.out.println(">>> Status hiện tại là: " + currentStatus);
            } else {
                System.out.println(">>> KHÔNG TÌM THẤY ĐƠN HÀNG " + orderId);
                return false;
            }
        }
        
        if (currentStatus == 6) {
            System.out.println("LỖI: Đơn hàng " + orderId + " đã bị hủy trước đó!");
            return false;
        }

        String sqlUpdateStatus = "UPDATE Orders SET status = ? WHERE order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlUpdateStatus)) {
            ps.setInt(1, newStatus);
            ps.setInt(2, orderId);
            int rows = ps.executeUpdate();
            System.out.println(">>> Đã chạy lệnh UPDATE. Số dòng bị ảnh hưởng: " + rows);
        }

            if (newStatus == 4) {
                String sqlRollbackStock = "UPDATE b " +
                        "SET b.stock_quantity = b.stock_quantity + od.quantity " +
                        "FROM Books b " +
                        "INNER JOIN OrderDetails od ON b.book_id = od.book_id " +
                        "WHERE od.order_id = ?";
                try (PreparedStatement psStock = conn.prepareStatement(sqlRollbackStock)) {
                    psStock.setInt(1, orderId);
                    int stockRows = psStock.executeUpdate();
                    System.out.println(
                            "Rollback Stock for Order ID: " + orderId + " (Đã hoàn lại " + stockRows + " đầu sách)");
                }
            }
            System.out.println(">>> CHUẨN BỊ COMMIT GIAO DỊCH...");
            conn.commit();
            System.out.println(">>> COMMIT THÀNH CÔNG! Trả về TRUE.");
            return true;

        } catch (Exception e) {
            System.out.println(">>> LỖI CỰC MẠNH: " + e.getMessage()); // In ra lỗi để đọc
            if (conn != null) {
                try {
                    System.out.println(">>> ĐANG ROLLBACK...");
                    conn.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // =========================================================================
    // 7. CÁC HÀM CÒN LẠI (GIỮ NGUYÊN KHÔNG ĐỔI)
    // =========================================================================
    public List<Order> getAllOrdersBySale(String sortBy, String sortOrder) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.username FROM Orders o "
                + "JOIN Users u ON o.user_id = u.user_id ";

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

    public int countOrders(String keyword, String fromDate, String toDate, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Orders o ");
        sql.append("JOIN Users u ON o.user_id = u.user_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            String searchKey = keyword.trim();
            if (searchKey.startsWith("#")) {
                searchKey = searchKey.replace("#", "").trim();
                sql.append(" AND o.order_id = ? ");
                int searchId = -1;
                try {
                    searchId = Integer.parseInt(searchKey);
                } catch (NumberFormatException e) {
                }
                params.add(searchId);
            } else {
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

        // CHANGED: Select u.username. Removed u.phone (we will use o.phone_number
        // instead)
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
            if (status.equals("Pending")) {
                params.add(1); // Chờ xử lý
            } else if (status.equals("Processing")) { // (Thêm nếu trên giao diện Admin có mục này)
                params.add(2); // Đang xử lý
            } else if (status.equals("Shipping")) {
                params.add(3); // [SỬA] Đang giao là 3
            } else if (status.equals("Completed")) {
                params.add(4); // [SỬA] Hoàn tất là 4
            } else if (status.equals("Cancelled")) {
                params.add(5); // [SỬA] Đã hủy là 5
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
        if ("name".equals(sortBy))
            col = "receiver_name"; // Đổi cột sắp xếp thành receiver_name
        if ("total".equals(sortBy))
            col = "total_amount";
        String order = "asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";

        // Chỉ truy vấn trên bảng Orders, tìm kiếm theo receiver_name
        String sql = "SELECT * FROM Orders WHERE (receiver_name LIKE ? OR phone_number LIKE ?) ORDER BY " + col + " "
                + order;

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
        // Mảng chứa 3 giá trị: [0] Tổng số đơn, [1] Đơn chờ xử lý, [2] Doanh thu (Đơn
        // đã hoàn thành status = 3)
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

                    // ==============================================================
                    // [MỚI THÊM] - Lấy thông tin Voucher để hiển thị lên Hóa Đơn
                    // ==============================================================
                    o.setVoucher_id(rs.getInt("voucher_id"));

                    java.math.BigDecimal dbDiscount = rs.getBigDecimal("discount_amount");
                    if (dbDiscount == null) {
                        o.setDiscountAmount(java.math.BigDecimal.ZERO);
                    } else {
                        o.setDiscountAmount(dbDiscount);
                    }
                    o.setShippingFee(rs.getDouble("shipping_fee"));
                    // ==============================================================

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

                    // ==============================================================
                    // [MỚI THÊM] - Lấy thông tin Voucher để hiển thị lên Hóa Đơn
                    // ==============================================================
                    o.setVoucher_id(rs.getInt("voucher_id"));

                    java.math.BigDecimal dbDiscount = rs.getBigDecimal("discount_amount");
                    if (dbDiscount == null) {
                        o.setDiscountAmount(java.math.BigDecimal.ZERO);
                    } else {
                        o.setDiscountAmount(dbDiscount);
                    }
                    o.setShippingFee(rs.getDouble("shipping_fee"));
                    // ==============================================================

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

    // =====================================================================
    // TÍNH NĂNG 3: ĐÁNH DẤU ĐÃ SỬ DỤNG VÀ TRỪ 1 LƯỢT TRONG KHO CHUNG
    // =====================================================================
    public void markVoucherAsUsed(int userId, int voucherId) {
        String sqlWallet = "UPDATE User_Vouchers SET is_used = 1 WHERE user_id = ? AND voucher_id = ?";
        String sqlGlobal = "UPDATE Vouchers SET usage_limit = usage_limit - 1 WHERE voucher_id = ?";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu Transaction
            try (PreparedStatement ps1 = conn.prepareStatement(sqlWallet);
                    PreparedStatement ps2 = conn.prepareStatement(sqlGlobal)) {

                // 1. Xóa vé trong ví
                ps1.setInt(1, userId);
                ps1.setInt(2, voucherId);
                ps1.executeUpdate();

                // 2. Trừ kho chung
                ps2.setInt(1, voucherId);
                ps2.executeUpdate();

                conn.commit(); // Chốt lưu
            } catch (Exception e) {
                conn.rollback(); // Nếu lỗi thì hoàn tác
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================================================================
    // TÍNH NĂNG 2: HOÀN TRẢ VOUCHER KHI HỦY ĐƠN HÀNG
    // =====================================================================
    public void refundVoucher(int userId, int voucherId) {
        String sqlWallet = "UPDATE User_Vouchers SET is_used = 0 WHERE user_id = ? AND voucher_id = ?";
        String sqlGlobal = "UPDATE Vouchers SET usage_limit = usage_limit + 1 WHERE voucher_id = ?";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(sqlWallet);
                    PreparedStatement ps2 = conn.prepareStatement(sqlGlobal)) {

                // 1. Phục hồi vé trong ví
                ps1.setInt(1, userId);
                ps1.setInt(2, voucherId);
                ps1.executeUpdate();

                // 2. Cộng trả lại kho chung
                ps2.setInt(1, voucherId);
                ps2.executeUpdate();

                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================================================================
    // CÁC HÀM PHỤC VỤ PHÂN TRANG (PAGINATION) DÀNH CHO SALE STAFF - ĐÃ GỘP
    // =========================================================================

    // 1. Hàm Đếm tổng số đơn (Gộp cả có lọc và không lọc)
    public int countOrdersBySale(int status, String searchQuery) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Orders WHERE (receiver_name LIKE ? OR phone_number LIKE ?)");

        // Nếu status != -1 thì nối thêm điều kiện lọc trạng thái vào SQL
        if (status != -1) {
            sql.append(" AND status = ?");
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            String searchPattern = "%" + searchQuery + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            if (status != -1) {
                ps.setInt(3, status);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 2. Hàm Lấy 10 đơn hàng (Gộp cả có lọc và không lọc)
    public List<Order> getOrdersBySalePaginated(int status, String sortBy, String sortOrder, String searchQuery,
            int page) {
        List<Order> list = new ArrayList<>();
        String col = "order_date";
        if ("name".equals(sortBy))
            col = "receiver_name";
        if ("total".equals(sortBy))
            col = "total_amount";
        String order = "asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM Orders WHERE (receiver_name LIKE ? OR phone_number LIKE ?)");

        // Nối điều kiện trạng thái nếu có
        if (status != -1) {
            sql.append(" AND status = ?");
        }

        // Nối phần Sắp xếp và Phân trang vào cuối
        sql.append(" ORDER BY ").append(col).append(" ").append(order)
                .append(" OFFSET ? ROWS FETCH NEXT 10 ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            String searchPattern = "%" + searchQuery + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            // Dùng biến paramIndex để theo dõi vị trí dấu chấm hỏi (?)
            int paramIndex = 3;
            if (status != -1) {
                ps.setInt(paramIndex, status);
                paramIndex++; // Tăng vị trí lên 1 nếu có dùng status
            }

            ps.setInt(paramIndex, (page - 1) * 10);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setUserName(rs.getString("receiver_name"));
                o.setPhoneNumber(rs.getString("phone_number"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getInt("status"));
                o.setShippingFee(rs.getDouble("shipping_fee"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // HÀM LƯU GHI CHÚ NỘI BỘ
    public void updateStaffNote(int orderId, String note) {
        String sql = "UPDATE Orders SET staff_note = ? WHERE order_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, note);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean insertReturnRequestAtomic(int orderId, String customerReason) {
        // Tuyệt chiêu INSERT INTO ... SELECT: Bốc thẳng sách từ OrderDetails ném sang ReturnRequests
        String sql = "INSERT INTO ReturnRequests (order_id, book_id, quantity, customer_reason, return_method, refund_preference, status, created_at) "
                   + "SELECT order_id, book_id, quantity, ?, 'pickup', 'refund_wallet', 1, GETDATE() "
                   + "FROM OrderDetails WHERE order_id = ?";
                   
        try (java.sql.Connection conn = getConnection(); 
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, customerReason);
            ps.setInt(2, orderId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.out.println("Lỗi khi bốc dữ liệu sang ReturnRequests: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean insertPartialReturnRequest(int orderId, int bookId, int quantity, String customer_reason, String proof_image, String mimeType) {
        // [QUAN TRỌNG] Thêm cột image_mime_type vào câu lệnh SQL và thêm 1 dấu ? tương ứng
        String sql = "INSERT INTO ReturnRequests (order_id, book_id, quantity, customer_reason, proof_image, image_mime_type, status, return_method, refund_preference) VALUES (?, ?, ?, ?, ?, ?, 1,'pickup','refund_wallet')";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, orderId);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);
            ps.setString(4, customer_reason);
            ps.setString(5, proof_image); // Lưu đường dẫn ảnh/video vào DB
            ps.setString(6, mimeType);   // [MỚI] Lưu định dạng file (vd: image/jpeg, video/mp4)
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi tại insertPartialReturnRequest: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Tính tổng số tiền hoàn lại (ĐÃ TRỪ HAO TỶ LỆ VOUCHER)
     */
    public double calculateRefundAmount(int orderId) {
        // Lấy Tổng tiền SP trả (RawRefund), Tiền Voucher (Discount) và Tổng tiền hàng ban đầu (SubTotal)
        String sql = "SELECT " +
                     "  SUM(rr.quantity * od.price) AS RawRefund, " +
                     "  MAX(o.discount_amount) AS Discount, " +
                     "  MAX(o.total_amount + o.discount_amount - o.shipping_fee) AS SubTotal " +
                     "FROM ReturnRequests rr " +
                     "JOIN OrderDetails od ON rr.order_id = od.order_id AND rr.book_id = od.book_id " +
                     "JOIN Orders o ON rr.order_id = o.order_id " +
                     "WHERE rr.order_id = ?";
                     
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                double rawRefund = rs.getDouble("RawRefund"); // Tiền gốc của các món bị trả
                double discount = rs.getDouble("Discount");   // Khách có áp voucher không?
                double subTotal = rs.getDouble("SubTotal");   // Tổng giá trị hàng hóa của cả đơn
                
                // Nếu đơn hàng bằng 0 hoặc không có hàng trả
                if (subTotal <= 0 || rawRefund == 0) return 0;
                
                // CÔNG THỨC E-COMMERCE: Tiền gốc SP trả - (Tỷ lệ phần trăm SP trả * Tiền Voucher)
                double finalRefund = rawRefund - (rawRefund / subTotal) * discount;
                
                // Làm tròn về số chẵn (Ví dụ: 90.000đ)
                return Math.round(finalRefund);
            }
        } catch (Exception e) {
            System.out.println("Lỗi tính toán tiền hoàn trả tỷ lệ: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // =========================================================================
    // HÀM MỚI: LẤY ĐƠN HÀNG ĐANG YÊU CẦU TRẢ (Sắp xếp theo ngày tạo yêu cầu)
    // =========================================================================
    public List<Order> getOrdersWithReturnRequests(String sortBy, String sortOrder, String searchQuery) {
        List<Order> list = new ArrayList<>();
        
        // Mặc định sắp xếp theo ngày gửi yêu cầu trả hàng (mới nhất lên đầu)
        String col = "MAX(r.created_at)"; 
        if ("name".equals(sortBy)) col = "MAX(o.receiver_name)";
        if ("total".equals(sortBy)) col = "MAX(o.total_amount)";
        
        String order = "asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";

        // Câu lệnh SQL JOIN 2 bảng và GROUP BY (Vì 1 đơn có thể có nhiều ReturnRequests)
        String sql = "SELECT o.*, MAX(r.created_at) as latest_return_request " +
                     "FROM Orders o " +
                     "JOIN ReturnRequests r ON o.order_id = r.order_id " +
                     "WHERE o.status = 7 " + 
                     "AND (o.receiver_name LIKE ? OR o.phone_number LIKE ?) " +
                     "GROUP BY o.order_id, o.user_id, o.order_date, o.total_amount, o.status, " +
                     "o.receiver_name, o.phone_number, o.shipping_address, o.payment_method, " +
                     "o.voucher_id, o.discount_amount, o.status_note, o.shipping_fee " +
                     "ORDER BY " + col + " " + order;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + (searchQuery == null ? "" : searchQuery) + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setUserName(rs.getString("receiver_name"));
                o.setPhoneNumber(rs.getString("phone_number"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setOrderDate(rs.getTimestamp("order_date")); // Ngày mua hàng
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getInt("status"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int autoCompleteDeliveredOrders() {
        // DATEDIFF(day, order_date, GETDATE()) >= 7 : So sánh ngày đặt với ngày hiện tại (nếu >= 7 ngày)
        String sql = "UPDATE Orders SET status = 5 " +
                     "WHERE status = 4 AND DATEDIFF(day, order_date, GETDATE()) >= 0";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            return ps.executeUpdate(); // Trả về số lượng đơn hàng đã được update
        } catch (Exception e) {
            System.out.println("Lỗi tại autoCompleteDeliveredOrders: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
