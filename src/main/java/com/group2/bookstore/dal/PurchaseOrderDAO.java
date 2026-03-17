package com.group2.bookstore.dal;

import com.group2.bookstore.model.PurchaseOrder;
import com.group2.bookstore.model.PurchaseOrderDetail;
import com.group2.bookstore.model.Book;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PurchaseOrderDAO extends DBContext {

    // =========================
    // 1. LIST + FILTER + PAGING
    // =========================
    public List<PurchaseOrder> getPurchaseOrders(String searchSupplier, Integer status, int page, int pageSize) {
        List<PurchaseOrder> list = new ArrayList<>();

        // Dùng StringBuilder để nối chuỗi SQL linh hoạt dựa trên điều kiện lọc
        StringBuilder sql = new StringBuilder(
                "SELECT po.*, s.supplier_name, u.username as created_by_name " +
                        "FROM Purchase_Orders po " +
                        "JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                        "JOIN Users u ON po.user_id = u.user_id " +
                        "WHERE 1=1 ");

        if (searchSupplier != null && !searchSupplier.trim().isEmpty()) {
            sql.append(" AND s.supplier_name LIKE ? ");
        }
        if (status != null) {
            sql.append(" AND po.status = ? ");
        }

        // Sắp xếp mới nhất lên đầu và Phân trang (OFFSET - FETCH NEXT của SQL Server)
        sql.append(" ORDER BY po.order_date DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (searchSupplier != null && !searchSupplier.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchSupplier.trim() + "%");
            }
            if (status != null) {
                ps.setInt(paramIndex++, status);
            }

            int offset = (page - 1) * pageSize;
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PurchaseOrder po = new PurchaseOrder();
                    po.setPurchaseOrderId(rs.getInt("purchase_order_id"));
                    po.setSupplierId(rs.getInt("supplier_id"));
                    po.setUserId(rs.getInt("user_id"));
                    po.setOrderDate(rs.getTimestamp("order_date"));
                    po.setTotalQuantity(rs.getInt("total_quantity"));
                    po.setTotalAmount(rs.getDouble("total_amount"));
                    po.setStatus(rs.getInt("status"));
                    po.setStatusNote(rs.getString("status_note"));

                    // Thuộc tính mở rộng lấy từ câu JOIN
                    po.setSupplierName(rs.getString("supplier_name"));
                    po.setCreatedByName(rs.getString("created_by_name"));

                    list.add(po);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số lượng Purchase Order để phục vụ tính toán số trang (Pagination)
     */
    public int countPurchaseOrders(String searchSupplier, Integer status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Purchase_Orders po " +
                        "JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                        "WHERE 1=1 ");

        if (searchSupplier != null && !searchSupplier.trim().isEmpty()) {
            sql.append(" AND s.supplier_name LIKE ? ");
        }
        if (status != null) {
            sql.append(" AND po.status = ? ");
        }

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (searchSupplier != null && !searchSupplier.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchSupplier.trim() + "%");
            }
            if (status != null) {
                ps.setInt(paramIndex++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // =======================================================
    // 1. LẤY CHI TIẾT ĐỂ NHẬP KHO (DÙNG MODEL CÓ SẴN)
    // =======================================================
    public List<PurchaseOrderDetail> getPoDetailsForReceive(int poId) {
        List<PurchaseOrderDetail> list = new ArrayList<>();
        String sql = "SELECT b.book_id, b.title, b.author, s.supplier_name, pod.expected_quantity, pod.price " +
                "FROM Purchase_Order_Details pod " +
                "JOIN Books b ON pod.book_id = b.book_id " +
                "JOIN Purchase_Orders po ON pod.purchase_order_id = po.purchase_order_id " +
                "JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                "WHERE pod.purchase_order_id = ?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, poId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // 1. Tạo Detail
                    PurchaseOrderDetail detail = new PurchaseOrderDetail();
                    detail.setExpectedQuantity(rs.getInt("expected_quantity"));
                    detail.setPrice(rs.getDouble("price"));

                    // 2. Tạo Book lồng bên trong
                    Book book = new Book();
                    book.setId(rs.getInt("book_id"));
                    book.setTitle(rs.getString("title"));
                    book.setAuthor(rs.getString("author"));
                    book.setSupplier(rs.getString("supplier_name")); // Mượn trường supplier của Book

                    // 3. Set Book vào Detail
                    detail.setBook(book);

                    list.add(detail);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =======================================================
    // 2. XÁC NHẬN NHẬP KHO (CỘNG KHO & ĐỔI TRẠNG THÁI PO)
    // =======================================================
    public boolean confirmReceive(int poId, String[] selectedBookIds) {
        String updateStockSql = "UPDATE Books SET stock_quantity = stock_quantity + ? WHERE book_id = ?";
        String updatePoStatusSql = "UPDATE Purchase_Orders SET status = 2 WHERE purchase_order_id = ?"; // 2: Received

        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Lấy chi tiết để biết số lượng cần cộng (expected_quantity)
            List<PurchaseOrderDetail> items = getPoDetailsForReceive(poId);

            // 2. Cập nhật số lượng kho bằng Batch (Thực thi nhiều lệnh cùng lúc cho nhanh)
            try (PreparedStatement psStock = conn.prepareStatement(updateStockSql)) {
                for (String bookIdStr : selectedBookIds) {
                    int bookId = Integer.parseInt(bookIdStr);

                    // Tìm item tương ứng trong danh sách để lấy đúng quantity
                    PurchaseOrderDetail currentItem = items.stream()
                            .filter(i -> i.getBook().getId() == bookId)
                            .findFirst().orElse(null);

                    if (currentItem != null) {
                        psStock.setInt(1, currentItem.getExpectedQuantity());
                        psStock.setInt(2, bookId);
                        psStock.addBatch(); // Đưa vào hàng chờ
                    }
                }
                psStock.executeBatch(); // Chạy đồng loạt tất cả các lệnh cộng kho
            }

            // 3. Cập nhật trạng thái PO thành Received
            try (PreparedStatement psStatus = conn.prepareStatement(updatePoStatusSql)) {
                psStatus.setInt(1, poId);
                psStatus.executeUpdate();
            }

            conn.commit(); // Thành công tất cả thì Commit (Lưu vào DB)
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                } // Lỗi thì Rollback
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
}
