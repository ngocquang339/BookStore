package com.group2.bookstore.dal;

import com.group2.bookstore.constant.OrderStatus;
import com.group2.bookstore.model.Order; // Bạn hãy dùng Model Order tương ứng của dự án
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class WarehouseOrderDAO extends DBContext {

    // 1. Lấy danh sách đơn hàng (có hỗ trợ tìm kiếm và lọc)
    // Chỉ lấy các đơn từ trạng thái PROCESSING trở đi (hoặc tất cả nếu bạn muốn)
    public List<Map<String, Object>> getOrdersForWarehouse(String searchName, int statusFilter) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.order_id, o.order_date, o.total_amount, o.status, o.shipping_address, u.fullname " +
                        "FROM Orders o JOIN Users u ON o.user_id = u.user_id WHERE 1=1 ");

        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND u.fullname LIKE ? ");
        }
        if (statusFilter > 0) {
            sql.append(" AND o.status = ? ");
        }
        sql.append(" ORDER BY o.order_date DESC");

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

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
        String sql = "SELECT b.title, od.quantity, od.price " +
                "FROM OrderDetails od JOIN Books b ON od.book_id = b.book_id " +
                "WHERE od.order_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> detail = new HashMap<>();
                detail.put("title", rs.getString("title"));
                detail.put("quantity", rs.getInt("quantity"));
                detail.put("price", rs.getDouble("price"));
                list.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Cập nhật trạng thái đơn hàng chung (cho Cancel, Processing...)
    public void updateOrderStatus(int orderId, int status) throws Exception {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new Exception("Lỗi cập nhật trạng thái: " + e.getMessage());
        }
    }

    // 4. SHIP ORDER (Quan trọng: Dùng Transaction để trừ kho và đổi trạng thái)
    public void shipOrder(int orderId) throws Exception {
        String updateStatusSql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        String deductStockSql = "UPDATE Books SET stock_quantity = stock_quantity - ? WHERE book_id = ?";
        String getDetailsSql = "SELECT book_id, quantity FROM OrderDetails WHERE order_id = ?";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // B1. Cập nhật trạng thái thành SHIPPING (4)
            try (PreparedStatement psStatus = conn.prepareStatement(updateStatusSql)) {
                psStatus.setInt(1, OrderStatus.SHIPPING);
                psStatus.setInt(2, orderId);
                psStatus.executeUpdate();
            }

            // B2. Lấy chi tiết đơn hàng và trừ tồn kho
            try (PreparedStatement psGet = conn.prepareStatement(getDetailsSql);
                    PreparedStatement psStock = conn.prepareStatement(deductStockSql)) {

                psGet.setInt(1, orderId);
                ResultSet rs = psGet.executeQuery();
                while (rs.next()) {
                    psStock.setInt(1, rs.getInt("quantity"));
                    psStock.setInt(2, rs.getInt("book_id"));
                    psStock.addBatch(); // Gom lệnh để thực thi nhanh hơn
                }
                psStock.executeBatch(); // Thực thi trừ kho
            }

            conn.commit(); // Thành công thì lưu toàn bộ
        } catch (Exception e) {
            if (conn != null)
                conn.rollback(); // Lỗi thì hoàn tác toàn bộ
            throw new Exception("Lỗi xuất kho: " + e.getMessage());
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
}