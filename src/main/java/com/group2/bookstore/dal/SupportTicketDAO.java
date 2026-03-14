package com.group2.bookstore.dal;

import com.group2.bookstore.model.SupportTicket;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SupportTicketDAO extends DBContext {

    // 1. Tạo Ticket mới (Thêm vào DB)
    public boolean createTicket(SupportTicket t) {
        String sql = "INSERT INTO Support_Tickets (user_id, issue_type, ticket_subject, ticket_message, status) " +
                     "VALUES (?, ?, ?, ?, 'Pending')";
                     
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getUserId());
            ps.setString(2, t.getIssueType());
            ps.setString(3, t.getTicketSubject());
            ps.setString(4, t.getTicketMessage());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Lấy danh sách Ticket của 1 User (Sắp xếp mới nhất lên đầu)
    public List<SupportTicket> getTicketsByUserId(int userId) {
        List<SupportTicket> list = new ArrayList<>();
        String sql = "SELECT * FROM Support_Tickets WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SupportTicket t = new SupportTicket();
                    t.setTicketId(rs.getInt("ticket_id"));
                    t.setUserId(rs.getInt("user_id"));
                    t.setIssueType(rs.getString("issue_type"));
                    t.setTicketSubject(rs.getString("ticket_subject"));
                    t.setTicketMessage(rs.getString("ticket_message"));
                    t.setStatus(rs.getString("status"));
                    t.setAdminReply(rs.getString("admin_reply"));
                    t.setCreatedAt(rs.getDate("created_at"));
                    
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}