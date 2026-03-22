package com.group2.bookstore.dal;

import com.group2.bookstore.model.Invoice;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InvoiceDAO extends DBContext {

    // 1. Lấy danh sách hóa đơn (Có hỗ trợ Lọc theo loại)
    public List<Invoice> getAllInvoices(String typeFilter) {
        List<Invoice> list = new ArrayList<>();

        String sql = "SELECT invoice_id, invoice_type, order_id, purchase_order_id, created_date, total_amount, status "
                +
                "FROM Invoices ";

        // Thêm điều kiện lọc nếu có
        if (typeFilter != null && (typeFilter.equals("SALE") || typeFilter.equals("PURCHASE"))) {
            sql += "WHERE invoice_type = ? ";
        }

        sql += "ORDER BY created_date DESC";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set tham số nếu có filter
            if (typeFilter != null && (typeFilter.equals("SALE") || typeFilter.equals("PURCHASE"))) {
                ps.setString(1, typeFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = new Invoice();
                    inv.setInvoiceId(rs.getInt("invoice_id"));
                    inv.setInvoiceType(rs.getString("invoice_type"));

                    int orderId = rs.getInt("order_id");
                    inv.setOrderId(rs.wasNull() ? null : orderId);

                    int poId = rs.getInt("purchase_order_id");
                    inv.setPurchaseOrderId(rs.wasNull() ? null : poId);

                    inv.setCreatedDate(rs.getTimestamp("created_date"));
                    inv.setTotalAmount(rs.getDouble("total_amount"));
                    inv.setStatus(rs.getString("status"));

                    list.add(inv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 2. Lấy chi tiết Sale Invoice
    public Map<String, Object> getSaleInvoiceDetail(int invoiceId) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> items = new ArrayList<>();

        String sql = "SELECT i.invoice_id, i.created_date, i.total_amount, i.status AS invoice_status, " +
                "o.order_id, o.shipping_address, o.phone_number AS order_phone, " +
                "u.fullname, u.email, " +
                "od.quantity, od.price, b.title " +
                "FROM Invoices i " +
                "JOIN Orders o ON i.order_id = o.order_id " +
                "JOIN Users u ON o.user_id = u.user_id " +
                "JOIN OrderDetails od ON o.order_id = od.order_id " +
                "JOIN Books b ON od.book_id = b.book_id " +
                "WHERE i.invoice_id = ? AND i.invoice_type = 'SALE'";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);

            try (ResultSet rs = ps.executeQuery()) {

                boolean hasData = false;

                while (rs.next()) {
                    if (!hasData) {
                        result.put("invoiceId", rs.getInt("invoice_id"));
                        result.put("createdDate", rs.getTimestamp("created_date"));
                        result.put("totalAmount", rs.getDouble("total_amount"));
                        result.put("status", rs.getString("invoice_status"));
                        result.put("relatedId", rs.getInt("order_id"));
                        result.put("customerName", rs.getString("fullname"));
                        result.put("customerPhone", rs.getString("order_phone"));
                        result.put("customerAddress", rs.getString("shipping_address"));
                        result.put("customerEmail", rs.getString("email"));
                        hasData = true;
                    }

                    Map<String, Object> item = new HashMap<>();
                    item.put("title", rs.getString("title"));
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("price", rs.getDouble("price"));

                    items.add(item);
                }

                if (!hasData)
                    return null;

                result.put("items", items);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    // 3. Lấy chi tiết Purchase Invoice
    public Map<String, Object> getPurchaseInvoiceDetail(int invoiceId) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> items = new ArrayList<>();

        String sql = "SELECT i.invoice_id, i.created_date, i.total_amount, i.status AS invoice_status, " +
                "po.purchase_order_id, s.supplier_name, s.phone, s.address, " +
                "pod.received_quantity AS quantity, pod.price, b.title " +
                "FROM Invoices i " +
                "JOIN Purchase_Orders po ON i.purchase_order_id = po.purchase_order_id " +
                "JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                "JOIN Purchase_Order_Details pod ON po.purchase_order_id = pod.purchase_order_id " +
                "JOIN Books b ON pod.book_id = b.book_id " +
                "WHERE i.invoice_id = ? AND i.invoice_type = 'PURCHASE'";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);

            try (ResultSet rs = ps.executeQuery()) {

                boolean hasData = false;

                while (rs.next()) {
                    if (!hasData) {
                        result.put("invoiceId", rs.getInt("invoice_id"));
                        result.put("createdDate", rs.getTimestamp("created_date"));
                        result.put("totalAmount", rs.getDouble("total_amount"));
                        result.put("status", rs.getString("invoice_status"));
                        result.put("relatedId", rs.getInt("purchase_order_id"));
                        result.put("supplierName", rs.getString("supplier_name"));
                        result.put("supplierPhone", rs.getString("phone"));
                        result.put("supplierAddress", rs.getString("address"));
                        hasData = true;
                    }

                    Map<String, Object> item = new HashMap<>();
                    item.put("title", rs.getString("title"));
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("price", rs.getDouble("price"));

                    items.add(item);
                }

                if (!hasData)
                    return null;

                result.put("items", items);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}