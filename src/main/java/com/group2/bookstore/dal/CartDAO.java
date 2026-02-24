package com.group2.bookstore.dal;

import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.CartItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DBContext {

    // 1. Lấy giỏ hàng của User từ Database
    public List<CartItem> getCartByUserId(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT ci.quantity, b.* FROM Cart c "
                   + "JOIN CartItems ci ON c.cart_id = ci.cart_id "
                   + "JOIN Books b ON ci.book_id = b.book_id "
                   + "WHERE c.user_id = ?";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setPrice(rs.getDouble("price"));
                book.setImageUrl(rs.getString("image")); // Hoặc setImageUrl tùy model của bạn
                book.setStockQuantity(rs.getInt("stock_quantity"));
                
                int quantity = rs.getInt("quantity");
                list.add(new CartItem(book, quantity));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Thêm hoặc Cập nhật sản phẩm vào Database
    public void addToCart(int userId, CartItem item) {
        try (Connection conn = getConnection()) {
            // Bước A: Kiểm tra User đã có giỏ hàng chưa
            int cartId = getCartId(userId, conn);
            if (cartId == -1) {
                // Chưa có -> Tạo mới giỏ hàng
                createCart(userId, conn);
                cartId = getCartId(userId, conn);
            }

            // Bước B: Kiểm tra sản phẩm đã có trong giỏ chưa
            String checkSql = "SELECT quantity FROM CartItems WHERE cart_id = ? AND book_id = ?";
            PreparedStatement psCheck = conn.prepareStatement(checkSql);
            psCheck.setInt(1, cartId);
            psCheck.setInt(2, item.getBook().getId());
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // Có rồi -> Cập nhật số lượng (Cộng dồn)
                int currentQty = rs.getInt("quantity");
                String updateSql = "UPDATE CartItems SET quantity = ? WHERE cart_id = ? AND book_id = ?";
                PreparedStatement psUpdate = conn.prepareStatement(updateSql);
                psUpdate.setInt(1, currentQty + item.getQuantity()); // Cộng dồn
                psUpdate.setInt(2, cartId);
                psUpdate.setInt(3, item.getBook().getId());
                psUpdate.executeUpdate();
            } else {
                // Chưa có -> Thêm mới (Insert)
                String insertSql = "INSERT INTO CartItems(cart_id, book_id, quantity, add_at) VALUES (?, ?, ?, GETDATE())";
                PreparedStatement psInsert = conn.prepareStatement(insertSql);
                psInsert.setInt(1, cartId);
                psInsert.setInt(2, item.getBook().getId());
                psInsert.setInt(3, item.getQuantity());
                psInsert.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3. Cập nhật số lượng (Dùng cho UpdateCartServlet)
    public void updateQuantity(int userId, int bookId, int newQuantity) {
        try (Connection conn = getConnection()) {
            int cartId = getCartId(userId, conn);
            if (cartId != -1) {
                String sql = "UPDATE CartItems SET quantity = ? WHERE cart_id = ? AND book_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, newQuantity);
                ps.setInt(2, cartId);
                ps.setInt(3, bookId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 4. Xóa sản phẩm khỏi giỏ
    public void removeItem(int userId, int bookId) {
        try (Connection conn = getConnection()) {
            int cartId = getCartId(userId, conn);
            if (cartId != -1) {
                String sql = "DELETE FROM CartItems WHERE cart_id = ? AND book_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, cartId);
                ps.setInt(2, bookId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- CÁC HÀM PHỤ TRỢ (PRIVATE) ---
    
    private int getCartId(int userId, Connection conn) throws Exception {
        String sql = "SELECT cart_id FROM Cart WHERE user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt("cart_id");
        return -1;
    }

    private void createCart(int userId, Connection conn) throws Exception {
        String sql = "INSERT INTO Cart(user_id, create_at) VALUES (?, GETDATE())";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.executeUpdate();
    }
}