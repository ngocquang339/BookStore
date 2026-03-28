package com.group2.bookstore.dal;

import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.Promotion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO extends DBContext {

    // 1. LẤY DANH SÁCH TẤT CẢ CÁC ĐỢT KHUYẾN MÃI (Sắp xếp mới nhất lên đầu)
    public List<Promotion> getAllPromotions() {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT * FROM Promotions ORDER BY promo_id DESC";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Promotion p = new Promotion();
                p.setPromoId(rs.getInt("promo_id"));
                p.setPromoName(rs.getString("promo_name"));
                p.setDiscountPercent(rs.getInt("discount_percent"));
                p.setStartDate(rs.getTimestamp("start_date"));
                p.setEndDate(rs.getTimestamp("end_date"));
                p.setActive(rs.getBoolean("is_active"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại getAllPromotions: " + e.getMessage());
        }
        return list;
    }

    // 2. TẠO MỘT ĐỢT KHUYẾN MÃI MỚI
    public boolean insertPromotion(String promoName, int discountPercent, String startDate, String endDate) {
        String sql = "INSERT INTO Promotions (promo_name, discount_percent, start_date, end_date, is_active) " +
                     "VALUES (?, ?, ?, ?, 1)";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, promoName);
            ps.setInt(2, discountPercent);
            ps.setString(3, startDate); // Truyền dưới dạng chuỗi 'YYYY-MM-DDTHH:mm' từ HTML Form
            ps.setString(4, endDate);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi tại insertPromotion: " + e.getMessage());
        }
        return false;
    }

    // 3. LẤY THÔNG TIN 1 ĐỢT KHUYẾN MÃI (Dùng để in tiêu đề ra màn hình)
    public Promotion getPromotionById(int promoId) {
        String sql = "SELECT * FROM Promotions WHERE promo_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promoId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Promotion(
                    rs.getInt("promo_id"), rs.getString("promo_name"),
                    rs.getInt("discount_percent"), rs.getTimestamp("start_date"),
                    rs.getTimestamp("end_date"), rs.getBoolean("is_active")
                );
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 4. LẤY DANH SÁCH ID CÁC CUỐN SÁCH ĐANG NẰM TRONG ĐỢT SALE NÀY
    public List<Integer> getBookIdsInPromotion(int promoId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT book_id FROM Promotion_Books WHERE promo_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promoId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("book_id"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 5. THÊM 1 CUỐN SÁCH VÀO FLASH SALE
    public boolean addBookToPromotion(int promoId, int bookId) {
        String sql = "INSERT INTO Promotion_Books (promo_id, book_id) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promoId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 6. XÓA 1 CUỐN SÁCH KHỎI FLASH SALE
    public boolean removeBookFromPromotion(int promoId, int bookId) {
        String sql = "DELETE FROM Promotion_Books WHERE promo_id = ? AND book_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promoId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 1. Lấy Chương trình khuyến mãi đang chạy (Ưu tiên cái sắp hết hạn nhất)
    public Promotion getCurrentActivePromotion() {
        String sql = "SELECT TOP 1 * FROM Promotions " +
                     "WHERE is_active = 1 " +
                     "AND GETDATE() BETWEEN start_date AND end_date " +
                     "ORDER BY end_date ASC"; 
                     
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Promotion(
                    rs.getInt("promo_id"), rs.getString("promo_name"),
                    rs.getInt("discount_percent"), rs.getTimestamp("start_date"),
                    rs.getTimestamp("end_date"), rs.getBoolean("is_active")
                );
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 2. Lấy danh sách sách của chương trình đó
    public List<Book> getBooksByPromotionId(int promoId) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.* FROM Books b " +
                     "JOIN Promotion_Books pb ON b.book_id = pb.book_id " +
                     "WHERE pb.promo_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promoId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getDouble("price"));
                b.setImageUrl(rs.getString("image"));
                b.setStockQuantity(rs.getInt("stock_quantity"));
                list.add(b);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // =========================================================================
    // HÀM LẤY PHẦN TRĂM GIẢM GIÁ ĐANG HOẠT ĐỘNG CỦA 1 CUỐN SÁCH
    // =========================================================================
    public int getActiveDiscountPercent(int bookId) {
        // Dùng TOP 1 và ORDER BY DESC để đề phòng trường hợp 1 cuốn sách bị add vào 2 chương trình KM cùng lúc
        // thì hệ thống sẽ ưu tiên lấy chương trình có mức giảm giá cao nhất.
        String sql = "SELECT TOP 1 p.discount_percent " +
                     "FROM Promotions p " +
                     "JOIN Promotion_Books pb ON p.promo_id = pb.promo_id " +
                     "WHERE pb.book_id = ? " +
                     "AND p.is_active = 1 " +
                     "AND GETDATE() BETWEEN p.start_date AND p.end_date " +
                     "ORDER BY p.discount_percent DESC";
                     
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("discount_percent"); // Trả về con số % giảm giá (VD: 50, 20)
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại getActiveDiscountPercent: " + e.getMessage());
            e.printStackTrace();
        }
        return 0; // Nếu không có khuyến mãi nào đang chạy, trả về 0
    }

    public boolean updatePromotion(int promoId, String promoName, int discountPercent, String startDate, String endDate, boolean isActive) {
        String sql = "UPDATE Promotions SET promo_name = ?, discount_percent = ?, start_date = ?, end_date = ?, is_active = ? WHERE promo_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, promoName);
            ps.setInt(2, discountPercent);
            ps.setString(3, startDate);
            ps.setString(4, endDate);
            ps.setBoolean(5, isActive); 
            ps.setInt(6, promoId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi tại updatePromotion: " + e.getMessage());
        }
        return false;
    }

    public boolean deletePromotion(int promoId) {
        String sql = "DELETE FROM Promotions WHERE promo_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promoId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi tại deletePromotion: " + e.getMessage());
        }
        return false;
    }
}