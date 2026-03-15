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

        String sql = "SELECT b.title, od.quantity, od.price, wl.location_code " +
                "FROM OrderDetails od " +
                "JOIN Books b ON od.book_id = b.book_id " +
                "LEFT JOIN Warehouse_Locations wl ON b.location_id = wl.location_id " +
                "WHERE od.order_id = ? " +
                "ORDER BY wl.zone, wl.rack, wl.shelf";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

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

        String sql = "SELECT o.order_date, o.shipping_address, u.fullname, u.phone_number "
                + "FROM Orders o "
                + "JOIN Users u ON o.user_id = u.user_id "
                + "WHERE o.order_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                info.put("fullname", rs.getString("fullname"));
                info.put("phone", rs.getString("phone_number"));
                info.put("address", rs.getString("shipping_address"));
                info.put("order_date", rs.getTimestamp("order_date"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return info;
    }

    public void confirmPicking(int orderId) throws Exception {

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

            while (rs.next()) {

                int bookId = rs.getInt("book_id");
                int quantity = rs.getInt("quantity");

                psStock.setInt(1, quantity);
                psStock.setInt(2, bookId);
                psStock.addBatch();
            }

            psStock.executeBatch();

            String sqlUpdateOrder = "UPDATE Orders SET status = 3 WHERE order_id = ?";

            PreparedStatement psOrder = conn.prepareStatement(sqlUpdateOrder);
            psOrder.setInt(1, orderId);
            psOrder.executeUpdate();

            conn.commit();

        } catch (Exception e) {

            if (conn != null)
                conn.rollback();
            throw e;

        } finally {

            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
}