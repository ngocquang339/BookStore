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
               String sql = "SELECT * FROM Vouchers WHERE status = 1 AND start_date <= GETDATE() AND end_date >= GETDATE() AND usage_limit > 0";    
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
        // ĐÃ SỬA: Lấy TẤT CẢ voucher, ưu tiên xếp cái chưa dùng lên trên cùng
        String sql = "SELECT uv.*, v.code, v.discount_amount, v.discount_percent, v.min_order_value, v.end_date " +
                     "FROM User_Vouchers uv " +
                     "INNER JOIN Vouchers v ON uv.voucher_id = v.voucher_id " +
                     "WHERE uv.user_id = ? " +
                     "ORDER BY uv.is_used ASC, v.end_date DESC, uv.saved_date DESC";
                     
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

     // 6. DÀNH CHO STAFF: LẤY TẤT CẢ VOUCHER (Kể cả hết hạn/hết lượt)
   
    public List<Voucher> getAllVouchersForStaff() {
        List<Voucher> list = new ArrayList<>();
      String sql = "SELECT * FROM Vouchers ORDER BY voucher_id DESC";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setId(rs.getInt("voucher_id"));
                v.setCode(rs.getString("code"));
                v.setDiscountAmount(rs.getDouble("discount_amount")); // Nếu null trong DB sẽ tự thành 0.0
                v.setDiscountPercent(rs.getInt("discount_percent"));  // Nếu null trong DB sẽ tự thành 0
                v.setMinOrderValue(rs.getDouble("min_order_value"));
                v.setStartDate(rs.getTimestamp("start_date"));
                v.setEndDate(rs.getTimestamp("end_date"));
                v.setUsageLimit(rs.getInt("usage_limit"));
                v.setMaxDiscount(rs.getDouble("max_discount"));
                v.setStatus(rs.getInt("status"));
                list.add(v);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // =====================================================================
    // 7. DÀNH CHO STAFF: THÊM MỚI VOUCHER
    // =====================================================================
    public void addVoucherForStaff(Voucher v) {
        // CẬP NHẬT 1: Thêm max_discount vào câu SQL (Giờ là 8 dấu chấm hỏi)
        String sql = "INSERT INTO Vouchers (code, discount_amount, discount_percent, min_order_value, start_date, end_date, usage_limit, max_discount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode().toUpperCase());
            
            if (v.getDiscountAmount() > 0) {
                ps.setDouble(2, v.getDiscountAmount());
            } else {
                ps.setNull(2, java.sql.Types.DOUBLE);
            }
            
            if (v.getDiscountPercent() > 0) {
                ps.setInt(3, v.getDiscountPercent());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            
            ps.setDouble(4, v.getMinOrderValue());
            ps.setTimestamp(5, v.getStartDate());
            ps.setTimestamp(6, v.getEndDate());
            ps.setInt(7, v.getUsageLimit());
            
            // CẬP NHẬT 2: Truyền max_discount vào vị trí số 8
            if (v.getMaxDiscount() > 0) {
                ps.setDouble(8, v.getMaxDiscount());
            } else {
                ps.setNull(8, java.sql.Types.DOUBLE);
            }
            
            ps.executeUpdate();
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }
    // =====================================================================
    // 8. DÀNH CHO STAFF: XÓA VOUCHER
    // =====================================================================
    public void deleteVoucher(int id) {
        String sqlDeleteWallet = "DELETE FROM User_Vouchers WHERE voucher_id = ?";
        String sqlDeleteMain = "DELETE FROM Vouchers WHERE voucher_id = ?";
        
        try (Connection conn = getConnection()) {
            // 1. Dọn dẹp mã này trong ví của khách hàng trước (nếu có ai lỡ lưu)
            try (PreparedStatement ps1 = conn.prepareStatement(sqlDeleteWallet)) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }
            
            // 2. Xóa mã gốc trong kho quản lý
            try (PreparedStatement ps2 = conn.prepareStatement(sqlDeleteMain)) {
                ps2.setInt(1, id);
                ps2.executeUpdate();
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }
    // =====================================================================
    // 9. DÀNH CHO STAFF: XEM THỐNG KÊ VOUCHER
    // =====================================================================
    public int[] getVoucherStats(int voucherId) {
        int[] stats = {0, 0}; // Index 0: Lượt đã lưu, Index 1: Lượt đã dùng
        
        // Đếm tổng số người đã lưu và đếm số người có is_used = 1
        String sql = "SELECT COUNT(*) as total_saved, SUM(CASE WHEN is_used = 1 THEN 1 ELSE 0 END) as total_used FROM User_Vouchers WHERE voucher_id = ?";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats[0] = rs.getInt("total_saved");
                    stats[1] = rs.getInt("total_used");
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return stats;
    }
}