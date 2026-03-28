package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.group2.bookstore.constant.OrderStatus;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.ReturnRequest;
import com.group2.bookstore.model.Supplier;

public class WarehouseOrderDAO extends DBContext {

    // 1. Lấy danh sách đơn hàng (có hỗ trợ tìm kiếm và lọc)
    // Chỉ lấy các đơn từ trạng thái PROCESSING trở đi (hoặc tất cả nếu bạn muốn)
    public List<Map<String, Object>> getOrdersForWarehouse(String searchName, int statusFilter) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.order_id, o.order_date, o.total_amount, o.status, o.shipping_address, u.fullname "
                        + "FROM Orders o JOIN Users u ON o.user_id = u.user_id WHERE 1=1 ");

        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND u.fullname LIKE ? ");
        }
        if (statusFilter > 0) {
            sql.append(" AND o.status = ? ");
        }
        sql.append(
                " ORDER BY "
                        + " CASE WHEN o.status = 2 THEN 0 ELSE 1 END, "
                        + " o.order_date DESC");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (searchName != null && !searchName.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchName + "%");
            }
            if (statusFilter > 0) {
                ps.setInt(paramIndex++, statusFilter);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("order_id", rs.getInt("order_id"));
                order.put("order_date", rs.getTimestamp("order_date"));
                order.put("total_amount", rs.getDouble("total_amount"));
                order.put("status", rs.getInt("status"));
                order.put("shipping_address", rs.getString("shipping_address"));
                order.put("fullname", rs.getString("fullname"));
                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy chi tiết đơn hàng (Dùng để hiển thị lên Modal)
    public List<Map<String, Object>> getOrderDetails(int orderId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT b.title, od.quantity, od.price, wl.location_code "
                + "FROM OrderDetails od "
                + "JOIN Books b ON od.book_id = b.book_id "
                + "LEFT JOIN Warehouse_Locations wl ON b.location_id = wl.location_id "
                + "WHERE od.order_id = ? "
                + "ORDER BY wl.zone, wl.rack, wl.shelf";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> detail = new HashMap<>();

                detail.put("title", rs.getString("title"));
                detail.put("quantity", rs.getInt("quantity"));
                detail.put("price", rs.getDouble("price"));
                detail.put("location_code", rs.getString("location_code")); // thêm dòng này

                list.add(detail);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 3. Cập nhật trạng thái đơn hàng chung (cho Cancel, Processing, Delivered...)
    public void updateOrderStatus(int orderId, int status) throws Exception {
        String sqlUpdateStatus = "UPDATE Orders SET status = ? WHERE order_id = ?";
        Connection conn = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Cập nhật trạng thái đơn hàng
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateStatus)) {
                ps.setInt(1, status);
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }

            // 2. TỰ ĐỘNG TẠO HÓA ĐƠN BÁN CHỈ KHI TRẠNG THÁI LÀ 5 (DELIVERED)
            if (status == 5) {
                // Kiểm tra chống trùng lặp: Đảm bảo order này chưa có hóa đơn
                String checkExistSql = "SELECT COUNT(*) FROM Invoices WHERE order_id = ?";
                boolean isInvoiceExist = false;
                try (PreparedStatement psCheck = conn.prepareStatement(checkExistSql)) {
                    psCheck.setInt(1, orderId);
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            isInvoiceExist = true; // Hóa đơn đã tồn tại
                        }
                    }
                }

                // Nếu chưa có hóa đơn thì mới tạo
                if (!isInvoiceExist) {
                    String insertSaleInvoiceSql = "INSERT INTO Invoices (invoice_type, order_id, total_amount, status) "
                            + "SELECT 'SALE', order_id, total_amount, 'COMPLETED' "
                            + "FROM Orders WHERE order_id = ?";
                    try (PreparedStatement psInvoice = conn.prepareStatement(insertSaleInvoiceSql)) {
                        psInvoice.setInt(1, orderId);
                        psInvoice.executeUpdate();
                    }
                }
            }

            conn.commit(); // Xác nhận lưu mọi thay đổi
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback(); // Nếu có bất kỳ lỗi gì xảy ra, hoàn tác lại toàn bộ
            }
            throw new Exception("Lỗi cập nhật trạng thái: " + e.getMessage());
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public void shipOrder(int orderId) throws Exception {

        String sql = "UPDATE Orders SET status = 4 WHERE order_id = ?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.executeUpdate();
        }
    }

    public Map<String, Object> getOrderCustomerInfo(int orderId) {
        Map<String, Object> info = new HashMap<>();

        // [ĐÃ SỬA]: Gọi thêm 3 cột total_amount, discount_amount, shipping_fee từ bảng
        // Orders
        String sql = "SELECT o.order_date, o.shipping_address, o.total_amount, o.discount_amount, o.shipping_fee, u.fullname, u.phone_number "
                + "FROM Orders o "
                + "JOIN Users u ON o.user_id = u.user_id "
                + "WHERE o.order_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                info.put("fullname", rs.getString("fullname"));
                info.put("phone", rs.getString("phone_number"));
                info.put("address", rs.getString("shipping_address"));
                info.put("order_date", rs.getTimestamp("order_date"));

                // [ĐÃ SỬA]: Nạp dữ liệu vào Map để gửi sang JSP
                info.put("totalAmount", rs.getDouble("total_amount"));
                info.put("discountAmount", rs.getDouble("discount_amount"));
                info.put("shippingFee", rs.getDouble("shipping_fee"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return info;
    }

    public void confirmPicking(int orderId, int userId) throws Exception {
        // Thêm tham số userId (ID của tài khoản Warehouse đang đăng nhập) vào hàm
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            String sqlGetItems = "SELECT book_id, quantity FROM OrderDetails WHERE order_id = ?";
            PreparedStatement psGet = conn.prepareStatement(sqlGetItems);
            psGet.setInt(1, orderId);
            ResultSet rs = psGet.executeQuery();

            String sqlUpdateStock = "UPDATE Books SET stock_quantity = stock_quantity - ? WHERE book_id = ?";
            PreparedStatement psStock = conn.prepareStatement(sqlUpdateStock);

            // TẠO THÊM LỆNH INSERT HISTORY
            String sqlHistory = "INSERT INTO Inventory_History (book_id, transaction_type, quantity_changed, related_id, created_by) VALUES (?, 'EXPORT', ?, ?, ?)";
            PreparedStatement psHistory = conn.prepareStatement(sqlHistory);

            while (rs.next()) {
                int bookId = rs.getInt("book_id");
                int quantity = rs.getInt("quantity");

                // 1. Lệnh trừ kho
                psStock.setInt(1, quantity);
                psStock.setInt(2, bookId);
                psStock.addBatch();

                // 2. Lệnh ghi log (Số lượng là số âm vì là xuất kho)
                psHistory.setInt(1, bookId);
                psHistory.setInt(2, -quantity);
                psHistory.setInt(3, orderId);
                psHistory.setInt(4, userId);
                psHistory.addBatch();
            }

            psStock.executeBatch();
            psHistory.executeBatch(); // Chạy lệnh lưu lịch sử

            String sqlUpdateOrder = "UPDATE Orders SET status = 3 WHERE order_id = ?";
            PreparedStatement psOrder = conn.prepareStatement(sqlUpdateOrder);
            psOrder.setInt(1, orderId);
            psOrder.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // DAO FOR PURCHASE ORDER
    public List<Supplier> getAllActiveSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM Suppliers WHERE is_active = 1";
        try (Connection conn = new DBContext().getConnection(); // Thay bằng class kết nối DB của bạn
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("supplier_id"));
                s.setName(rs.getString("supplier_name"));
                // Set thêm các trường khác nếu cần...
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy danh sách Sách để Warehouse chọn
    public List<Book> getAllActiveBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books WHERE is_active = 1";
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setStockQuantity(rs.getInt("stock_quantity"));
                b.setPrice(rs.getDouble("price")); // Giá bán (để tham khảo)
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. HÀM QUAN TRỌNG: Tạo mới Đơn nhập hàng & Chi tiết
    public boolean createPurchaseOrder(int supplierId, int userId, String statusNote, String[] bookIds,
            String[] expectedQuantities,
            String[] importPrices) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;
        boolean isSuccess = false;

        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Tính tổng
            int totalQuantity = 0;
            double totalAmount = 0;
            for (int i = 0; i < bookIds.length; i++) {
                int qty = Integer.parseInt(expectedQuantities[i]);
                double price = Double.parseDouble(importPrices[i]);
                totalQuantity += qty;
                totalAmount += (qty * price);
            }

            // 2. Insert Purchase Order + lấy ID (SQL Server chuẩn)
            String sqlOrder = "INSERT INTO Purchase_Orders (supplier_id, user_id, order_date, total_quantity, total_amount, status, status_note) "
                    + "OUTPUT INSERTED.purchase_order_id "
                    + "VALUES (?, ?, GETDATE(), ?, ?, 0, ?)";

            psOrder = conn.prepareStatement(sqlOrder);
            psOrder.setInt(1, supplierId);
            psOrder.setInt(2, userId);
            psOrder.setInt(3, totalQuantity);
            psOrder.setDouble(4, totalAmount);
            psOrder.setString(5, statusNote);

            rs = psOrder.executeQuery();

            int newOrderId = 0;
            if (rs.next()) {
                newOrderId = rs.getInt(1);
            }

            // 3. Insert chi tiết
            if (newOrderId > 0) {
                String sqlDetail = "INSERT INTO Purchase_Order_Details (purchase_order_id, book_id, expected_quantity, received_quantity, price) "
                        + "VALUES (?, ?, ?, 0, ?)";

                psDetail = conn.prepareStatement(sqlDetail);

                for (int i = 0; i < bookIds.length; i++) {
                    psDetail.setInt(1, newOrderId);
                    psDetail.setInt(2, Integer.parseInt(bookIds[i]));
                    psDetail.setInt(3, Integer.parseInt(expectedQuantities[i]));
                    psDetail.setDouble(4, Double.parseDouble(importPrices[i]));
                    psDetail.addBatch();
                }

                psDetail.executeBatch();
                // =========================================================
                // 🔔 GỬI THÔNG BÁO CHO ADMIN (NEW PO TỪ KHO)
                // =========================================================
                NotificationDAO notifDao = new NotificationDAO();
                String msg = "📦 Kho vừa tạo Đơn Nhập Hàng mới (#PO-" + newOrderId + "). Cần Admin duyệt chi phí!";
                String link = "/admin/po/review?id=" + newOrderId;
                notifDao.insertAdminNotification(msg, link);
                conn.commit();
                isSuccess = true;
            } else {
                conn.rollback();
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psOrder != null) {
                    psOrder.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psDetail != null) {
                    psDetail.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }

        return isSuccess;
    }
    // Thêm vào WarehouseOrderDAO.java

    // Hàm lấy danh sách đơn trả hàng (Group by OrderId để không bị lặp dòng khi
    // hiển thị)
    // 1. Lấy danh sách Đơn trả hàng (CHỈ lấy các đơn đã Approved - Đang chờ nhận
    // hàng)
    public List<ReturnRequest> getReturnOrders(String searchName, int statusFilter) {
        List<ReturnRequest> list = new ArrayList<>();

        // Truy vấn trực tiếp từ bảng ReturnRequests
        StringBuilder sql = new StringBuilder(
                "SELECT r.*, b.title AS book_title, u.fullname AS customer_name "
                        + "FROM ReturnRequests r "
                        + "JOIN Books b ON r.book_id = b.book_id "
                        + "JOIN Orders o ON r.order_id = o.order_id "
                        + "JOIN Users u ON o.user_id = u.user_id "
                        + "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND u.fullname LIKE ? ");
            params.add("%" + searchName + "%");
        }

        if (statusFilter > 0) {
            sql.append(" AND r.status = ? ");
            params.add(statusFilter);
        }

        sql.append(" ORDER BY r.created_at DESC");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReturnRequest req = new ReturnRequest();
                req.setReturnId(rs.getInt("return_id"));
                req.setOrderId(rs.getInt("order_id"));
                req.setBookId(rs.getInt("book_id"));
                req.setQuantity(rs.getInt("quantity"));
                req.setCustomerReason(rs.getString("customer_reason"));
                req.setReturnMethod(rs.getString("return_method"));
                req.setRefundPreference(rs.getString("refund_preference"));
                req.setStatus(rs.getInt("status"));
                req.setAdminNote(rs.getString("admin_note"));
                req.setCreatedAt(rs.getTimestamp("created_at"));

                req.setBookTitle(rs.getString("book_title"));
                req.setCustomerName(rs.getString("customer_name"));

                list.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy chi tiết trả hàng cho Modal
    public List<ReturnRequest> getReturnOrderDetails(int orderId) {
        List<ReturnRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, b.title AS book_title, u.fullname AS customer_name "
                + "FROM ReturnRequests r "
                + "JOIN Books b ON r.book_id = b.book_id "
                + "JOIN Orders o ON r.order_id = o.order_id "
                + "JOIN Users u ON o.user_id = u.user_id "
                + "WHERE r.order_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReturnRequest req = new ReturnRequest();
                req.setReturnId(rs.getInt("return_id"));
                req.setOrderId(rs.getInt("order_id"));
                req.setBookId(rs.getInt("book_id"));
                req.setQuantity(rs.getInt("quantity"));
                req.setCustomerReason(rs.getString("customer_reason"));
                req.setReturnMethod(rs.getString("return_method"));
                req.setRefundPreference(rs.getString("refund_preference"));
                req.setStatus(rs.getInt("status"));
                req.setAdminNote(rs.getString("admin_note"));
                req.setCreatedAt(rs.getTimestamp("created_at"));

                req.setBookTitle(rs.getString("book_title"));
                req.setCustomerName(rs.getString("customer_name"));

                list.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Sửa lại hàm cộng kho: Chỉ cộng lại đúng số lượng hàng có trong ReturnRequests
    public void confirmReturnToStock(int orderId) throws Exception {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // 1. Lấy danh sách sách thực tế khách trả từ ReturnRequests thay vì
            // OrderDetails
            String sqlItems = "SELECT book_id, quantity FROM ReturnRequests WHERE order_id = ?";
            PreparedStatement psItems = conn.prepareStatement(sqlItems);
            psItems.setInt(1, orderId);
            ResultSet rs = psItems.executeQuery();

            // 2. CỘNG lại tồn kho (+)
            String sqlUpdateStock = "UPDATE Books SET stock_quantity = stock_quantity + ? WHERE book_id = ?";
            PreparedStatement psStock = conn.prepareStatement(sqlUpdateStock);
            while (rs.next()) {
                psStock.setInt(1, rs.getInt("quantity"));
                psStock.setInt(2, rs.getInt("book_id"));
                psStock.addBatch();
            }
            psStock.executeBatch();

            // 3. Cập nhật trạng thái Orders: RETURN_COMPLETED (10)
            String sqlStatus = "UPDATE Orders SET status = ? WHERE order_id = ?";
            PreparedStatement psStatus = conn.prepareStatement(sqlStatus);
            psStatus.setInt(1, OrderStatus.RETURN_COMPLETED);
            psStatus.setInt(2, orderId);
            psStatus.executeUpdate();

            // 4. (Tùy chọn) Cập nhật trạng thái của ReturnRequests đồng bộ với Orders
            String sqlRR = "UPDATE ReturnRequests SET status = ? WHERE order_id = ?";
            PreparedStatement psRR = conn.prepareStatement(sqlRR);
            psRR.setInt(1, OrderStatus.RETURN_COMPLETED);
            psRR.setInt(2, orderId);
            psRR.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }

    // Lấy thông tin ReturnRequest thay vì Order
    public void updateReturnRequestStatus(int orderId, int status) throws Exception {
        String sql = "UPDATE ReturnRequests SET status = ? WHERE order_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, orderId); // ✅ THÊM DÒNG NÀY
            ps.executeUpdate();
        }
    }

    public void processQualityControl(int orderId, String action, String failReason) throws Exception {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // 1. LẤY SỐ LƯỢNG VÀ RETURN_ID
            int returnId = 0;
            String sqlItems = "SELECT return_id, book_id, quantity FROM ReturnRequests WHERE order_id = ?";
            PreparedStatement psItems = conn.prepareStatement(sqlItems);
            psItems.setInt(1, orderId);
            ResultSet rs = psItems.executeQuery();

            List<int[]> bookQuantities = new ArrayList<>();
            while (rs.next()) {
                if (returnId == 0)
                    returnId = rs.getInt("return_id");
                bookQuantities.add(new int[] { rs.getInt("book_id"), rs.getInt("quantity") });
            }

            NotificationDAO notifDao = new NotificationDAO();

            // CHỈ XỬ LÝ PASS
            if ("PASS".equals(action)) {

                // 2. CỘNG KHO
                String sqlUpdateStock = "UPDATE Books SET stock_quantity = stock_quantity + ? WHERE book_id = ?";
                PreparedStatement psStock = conn.prepareStatement(sqlUpdateStock);
                for (int[] bq : bookQuantities) {
                    psStock.setInt(1, bq[1]);
                    psStock.setInt(2, bq[0]);
                    psStock.addBatch();
                }
                psStock.executeBatch();

                // 3. UPDATE STATUS = 8
                String sqlUpdateNote = "UPDATE ReturnRequests SET status = 8, admin_note = CONCAT(ISNULL(admin_note, ''), CHAR(13), ?) WHERE order_id = ?";
                PreparedStatement psUpdateNote = conn.prepareStatement(sqlUpdateNote);
                psUpdateNote.setString(1, "[Warehouse]: Hàng đã qua QC và được nhập lại vào kho. Chờ hoàn tiền.");
                psUpdateNote.setInt(2, orderId);
                psUpdateNote.executeUpdate();

                // 🔔 THÔNG BÁO
                String msg = "💰 Kho đã nhận hàng (Passed QC) cho Đơn #" + orderId + ". Cần hoàn tiền ngay!";
                String link = "/admin/returns/review?id=" + returnId;
                notifDao.insertAdminNotification(msg, link);
            }

            conn.commit();
        } catch (Exception e) {
            if (conn != null)
                conn.rollback();
            throw e;
        } finally {
            if (conn != null)
                conn.close();
        }
    }
}
