package com.group2.bookstore.dal;

import com.group2.bookstore.model.UserVoucher;
import com.group2.bookstore.model.Voucher;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO extends DBContext { // Giả sử nhóm bạn dùng DBContext để kết nối

    // =====================================================================
    // 1. LẤY DANH SÁCH VOUCHER ĐANG HOẠT ĐỘNG (Để hiện ra Trang chủ)
    // =====================================================================
    public List<Voucher> getAllActiveVouchers() {
        List<Voucher> list = new ArrayList<>();
        // Chỉ lấy những mã: Đang bật (status=1), còn hạn (end_date >= hiện tại) và còn lượt dùng (>0)
        String sql = "SELECT * FROM Vouchers WHERE status = 1 AND end_date >= GETDATE() AND usage_limit > 0";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setId(rs.getInt("voucher_id"));
                v.setCode(rs.getString("code"));
                v.setDiscountAmount(rs.getDouble("discount_amount"));
                v.setDiscountPercent(rs.getInt("discount_percent"));
                v.setMinOrderValue(rs.getDouble("min_order_value"));
                v.setStartDate(rs.getTimestamp("start_date"));
                v.setEndDate(rs.getTimestamp("end_date"));
                v.setUsageLimit(rs.getInt("usage_limit"));
                v.setStatus(rs.getInt("status"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =====================================================================
    // 2. KHÁCH HÀNG BẤM "LƯU VOUCHER" VÀO VÍ CÁ NHÂN
    // =====================================================================
    // Trả về String để báo lỗi cụ thể (Thành công, Đã lưu rồi, hoặc Lỗi)
    public String saveVoucherToWallet(int userId, int voucherId) {
        // Kiểm tra xem khách đã lưu mã này chưa (Ngăn chặn lưu trùng)
        String sqlCheck = "SELECT * FROM User_Vouchers WHERE user_id = ? AND voucher_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
             
            psCheck.setInt(1, userId);
            psCheck.setInt(2, voucherId);
            ResultSet rsCheck = psCheck.executeQuery();
            if (rsCheck.next()) {
                return "EXISTED"; // Đã lưu mã này rồi
            }
            
            // Nếu chưa lưu thì Insert vào ví
            String sqlInsert = "INSERT INTO User_Vouchers (user_id, voucher_id, is_used, saved_date) VALUES (?, ?, 0, GETDATE())";
            try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert)) {
                psInsert.setInt(1, userId);
                psInsert.setInt(2, voucherId);
                int rows = psInsert.executeUpdate();
                if (rows > 0) return "SUCCESS";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "ERROR";
    }

    // =====================================================================
    // 3. LẤY "VÍ VOUCHER" CỦA 1 KHÁCH HÀNG (Để hiện ở trang Giỏ hàng / Cá nhân)
    // =====================================================================
    public List<UserVoucher> getUserWallet(int userId) {
        List<UserVoucher> wallet = new ArrayList<>();
        
        // Dùng INNER JOIN để lôi cả thông tin của cái Voucher ra
        // Chỉ lấy những mã chưa dùng (is_used = 0) và chưa hết hạn
        String sql = "SELECT uv.*, v.code, v.discount_amount, v.discount_percent, v.min_order_value, v.end_date " +
                     "FROM User_Vouchers uv " +
                     "INNER JOIN Vouchers v ON uv.voucher_id = v.voucher_id " +
                     "WHERE uv.user_id = ? AND uv.is_used = 0 AND v.end_date >= GETDATE() " +
                     "ORDER BY uv.saved_date DESC";
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Tạo object Voucher lồng bên trong
                    Voucher v = new Voucher();
                    v.setId(rs.getInt("voucher_id"));
                    v.setCode(rs.getString("code"));
                    v.setDiscountAmount(rs.getDouble("discount_amount"));
                    v.setDiscountPercent(rs.getInt("discount_percent"));
                    v.setMinOrderValue(rs.getDouble("min_order_value"));
                    v.setEndDate(rs.getTimestamp("end_date"));

                    // Tạo object UserVoucher
                    UserVoucher uv = new UserVoucher();
                    uv.setUserId(rs.getInt("user_id"));
                    uv.setVoucherId(rs.getInt("voucher_id"));
                    uv.setUsed(rs.getBoolean("is_used"));
                    uv.setSavedDate(rs.getTimestamp("saved_date"));
                    uv.setVoucher(v); // Gắn voucher vào ví
                    
                    wallet.add(uv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return wallet;
    }

    // =====================================================================
    // 4. ĐÁNH DẤU ĐÃ SỬ DỤNG VÀ TRỪ 1 LƯỢT TRONG KHO CHUNG (Khi đặt hàng)
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
    // 5. HOÀN TRẢ VOUCHER VÀO VÍ KHI HỦY ĐƠN HÀNG
    // =====================================================================
    public void refundVoucher(int userId, int voucherId) {
        String sqlWallet = "UPDATE User_Vouchers SET is_used = 0 WHERE user_id = ? AND voucher_id = ?";
        String sqlGlobal = "UPDATE Vouchers SET usage_limit = usage_limit + 1 WHERE voucher_id = ?";
        
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu Transaction
            try (PreparedStatement ps1 = conn.prepareStatement(sqlWallet);
                 PreparedStatement ps2 = conn.prepareStatement(sqlGlobal)) {
                
                // 1. Phục hồi vé trong ví
                ps1.setInt(1, userId);
                ps1.setInt(2, voucherId);
                ps1.executeUpdate();
                
                // 2. Cộng trả lại kho chung
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
}