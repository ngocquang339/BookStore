package com.group2.bookstore.dal;

import java.math.BigDecimal;
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
    public void createOrder(User user, List<CartItem> cart, String receiverName, String shippingAddress, String phone, double total, String paymentMethod, int orderStatus, int voucherId, BigDecimal discountAmount) {
        
        // Đã thêm voucher_id và discount_amount vào câu lệnh INSERT
        String sqlOrder = "INSERT INTO Orders(user_id, order_date, total_amount, status, receiver_name, shipping_address, phone_number, payment_method, voucher_id, discount_amount) VALUES (?, GETDATE(), ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection cn = null; 

        try {
            cn = getConnection();
            cn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Lưu Order
            PreparedStatement ps = cn.prepareStatement(sqlOrder, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, user.getId());
            ps.setDouble(2, total);
            ps.setInt(3, orderStatus);         
            ps.setString(4, receiverName);     
            ps.setString(5, shippingAddress);  
            ps.setString(6, phone);            
            ps.setString(7, paymentMethod);    
            
            // ==============================================================
            // [MỚI THÊM] Set giá trị cho cột số 8 (voucher_id) và 9 (discount_amount)
            // ==============================================================
            if (voucherId > 0) {
                ps.setInt(8, voucherId);
            } else {
                ps.setNull(8, java.sql.Types.INTEGER); // Không xài mã thì lưu NULL
            }
            
            if (discountAmount == null) {
                ps.setBigDecimal(9, java.math.BigDecimal.ZERO);
            } else {
                ps.setBigDecimal(9, discountAmount);
            }
            // ==============================================================

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

            // 3. TRỪ SỐ LƯỢNG TỒN KHO TRỰC TIẾP Ở ĐÂY (Reserve/Deduct Stock)
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

    // Hàm đã được đổi kiểu trả về thành boolean để báo cho Servlet biết là Thành công hay Thất bại
    public boolean updateOrderStatus(int orderId, int newStatus) {
        Connection conn = null; 
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // =========================================================
            // BƯỚC 1: LẤY TRẠNG THÁI HIỆN TẠI CỦA ĐƠN HÀNG ĐỂ KIỂM TRA
            // =========================================================
            int currentStatus = -1;
            String sqlCheck = "SELECT status FROM Orders WHERE order_id = ?";
            try (PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
                psCheck.setInt(1, orderId);
                ResultSet rs = psCheck.executeQuery();
                if (rs.next()) {
                    currentStatus = rs.getInt("status");
                } else {
                    return false; // Không tìm thấy đơn hàng
                }
            }
            // =========================================================
            // BƯỚC 2: CHẶN ĐỨNG NẾU ĐƠN HÀNG ĐÃ Ở TRẠNG THÁI CUỐI (Đã Hủy)
            // =========================================================
            if (currentStatus == 5) {
                System.out.println("LỖI: Đơn hàng " + orderId + " đã bị hủy trước đó, không thể thay đổi trạng thái nữa!");
                return false; // Từ chối cập nhật
            }

            // =========================================================
            // BƯỚC 3: NẾU HỢP LỆ THÌ TIẾN HÀNH CẬP NHẬT TRẠNG THÁI MỚI
            // =========================================================
            String sqlUpdateStatus = "UPDATE Orders SET status = ? WHERE order_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateStatus)) {
                ps.setInt(1, newStatus);
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }

            // =========================================================
            // BƯỚC 4: ROLLBACK STOCK (CHỈ CHẠY KHI TỪ TRẠNG THÁI KHÁC CHUYỂN SANG 4)
            // =========================================================
            if (newStatus == 4) {
                String sqlRollbackStock = "UPDATE b " +
                                          "SET b.stock_quantity = b.stock_quantity + od.quantity " +
                                          "FROM Books b " +
                                          "INNER JOIN OrderDetails od ON b.book_id = od.book_id " +
                                          "WHERE od.order_id = ?";
                try (PreparedStatement psStock = conn.prepareStatement(sqlRollbackStock)) {
                    psStock.setInt(1, orderId);
                    int stockRows = psStock.executeUpdate();
                    System.out.println("Rollback Stock for Order ID: " + orderId + " (Đã hoàn lại " + stockRows + " đầu sách)");
                }
            }

            conn.commit(); // Hoàn tất an toàn
            return true;
            
        } catch (Exception e) {
            if (conn != null) {
                try {
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
}
