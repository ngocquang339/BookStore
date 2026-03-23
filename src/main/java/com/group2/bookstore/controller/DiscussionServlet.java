package com.group2.bookstore.controller;

import com.group2.bookstore.dal.DiscussionDAO;
import com.group2.bookstore.dal.NotificationDAO;
import com.group2.bookstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DiscussionServlet", urlPatterns = {"/discussion"})
public class DiscussionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập!\"}");
            return;
        }

        try {
            DiscussionDAO dao = new DiscussionDAO();
            String action = request.getParameter("action");

            // NHÁNH: GỬI CÂU TRẢ LỜI
            if ("reply".equals(action)) {
                int discussionId = Integer.parseInt(request.getParameter("discussionId"));
                String replyContent = request.getParameter("replyContent");
                if (replyContent != null && replyContent.length() > 800) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false, \"message\": \"Câu trả lời không được vượt quá 500 ký tự!\"}");
                    return;
                }
                // Lấy thêm Product ID (pid) từ frontend gửi lên để làm cái link bấm vào thông báo
                String pidStr = request.getParameter("pid"); 
                // [THÊM MỚI] - XỬ LÝ EX 2: BỘ LỌC TỪ NGỮ CẤM
                if (containsBadWords(replyContent)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false, \"message\": \"Your comment contains inappropriate language and cannot be posted.\"}");
                    return;
                }
                
                int newReplyId = dao.createReply(discussionId, user.getId(), replyContent);
                
                if (newReplyId > 0) {
                    
                    // ====================================================================
                    // --- BẮT ĐẦU LOGIC BẮT TAG @USERNAME VÀ GỬI THÔNG BÁO (BẢN PRO) ---
                    // ====================================================================
                    try {
                        /* * GIẢI THÍCH REGEX MỚI: (^|\\s)@(\\w+)
                         * 1. (^|\\s) : Bắt buộc trước dấu @ phải là bắt đầu dòng HOẶC một khoảng trắng.
                         * => Chặn được lỗi dính email (abc@gmail.com sẽ bị bỏ qua).
                         * 2. @       : Phải có dấu @
                         * 3. (\\w+)  : Ký tự a-z, A-Z, 0-9 và dấu gạch dưới (Chính là username hợp lệ).
                         */
                        java.util.regex.Pattern p = java.util.regex.Pattern.compile("(^|\\s)@(\\w+)");
                        java.util.regex.Matcher m = p.matcher(replyContent);
                        NotificationDAO notifDAO = new NotificationDAO();
                        
                        // Dùng Set để LỌC TRÙNG LẶP. Nếu 1 comment tag "@sa" 3 lần, chỉ gửi 1 thông báo thôi!
                        java.util.Set<String> notifiedUsers = new java.util.HashSet<>();
                        
                        while (m.find()) {
                            // Lấy group(2) vì group(1) đang chứa cái khoảng trắng ở đầu rồi
                            String taggedUsername = m.group(2); 
                            
                            // Kiểm tra 2 điều kiện:
                            // - Không tự tag chính mình
                            // - Chưa gửi thông báo cho user này trong cái comment hiện tại
                            if (!taggedUsername.equals(user.getUsername()) && !notifiedUsers.contains(taggedUsername)) {
                                
                                // Vào DB tìm xem có user này thật không (Chặn vụ @hihi vì DB chỉ có @hi)
                                int taggedUserId = notifDAO.getUserIdByUsername(taggedUsername);
                                
                                if (taggedUserId != -1) {
                                    String message = "<b>" + user.getUsername() + "</b> đã nhắc đến bạn trong một bình luận.";
                                    String link = "detail?pid=" + pidStr + "#reply-box-" + newReplyId; 
                                    
                                    // Bắn thông báo xuống DB
                                    notifDAO.createNotification(taggedUserId, message, link);
                                    
                                    // Đánh dấu là đã gửi cho ông này rồi, tý vòng lặp có gặp lại thì bỏ qua
                                    notifiedUsers.add(taggedUsername);
                                }
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace(); // Lỗi thông báo thì in ra console, không làm sập chức năng cmt
                    }
                    // ====================================================================
                    // --- KẾT THÚC LOGIC THÔNG BÁO ---
                    // ====================================================================

                    response.getWriter().write("{\"success\": true, \"replyId\": " + newReplyId + "}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false}");
                }
            } 
            // 2. THÊM 2 NHÁNH MỚI NÀY VÀO DƯỚI NÓ:
            else if ("deleteReply".equals(action)) {
                int replyId = Integer.parseInt(request.getParameter("replyId"));
                boolean success = dao.deleteReply(replyId, user.getId());
                response.getWriter().write("{\"success\": " + success + "}");
            }
            else if ("updateReply".equals(action)) {
                int replyId = Integer.parseInt(request.getParameter("replyId"));
                String content = request.getParameter("replyContent");
                if (content != null && content.length() > 800) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false, \"message\": \"Câu trả lời không được vượt quá 500 ký tự!\"}");
                    return;
                }
                boolean success = dao.updateReply(replyId, user.getId(), content);
                response.getWriter().write("{\"success\": " + success + "}");
            } 
            // 2. NẾU LÀ XÓA CÂU HỎI
            else if ("delete".equals(action)) {
                int discussionId = Integer.parseInt(request.getParameter("discussionId"));
                boolean success = dao.deleteDiscussion(discussionId, user.getId());
                response.getWriter().write("{\"success\": " + success + "}");
            }
            // 3. NẾU LÀ SỬA CÂU HỎI
            else if ("update".equals(action)) {
                int discussionId = Integer.parseInt(request.getParameter("discussionId"));
                String title = request.getParameter("discussionTitle");
                String content = request.getParameter("discussionContent");
                String topicTag = request.getParameter("topicTag");
                boolean hasSpoiler = request.getParameter("hasSpoiler") != null; // Cứ có tick là true
                
                boolean success = dao.updateDiscussion(discussionId, user.getId(), title, content, hasSpoiler, topicTag);
                response.getWriter().write("{\"success\": " + success + "}");
            }
            // ---------------------------------------------------------
            // XỬ LÝ BÁO CÁO VI PHẠM (Dành cho cả Hỏi và Đáp)
            // ---------------------------------------------------------
            else if ("report".equals(action)) {
                String reportType = request.getParameter("reportType"); // "discussion" hoặc "reply"
                String targetIdStr = request.getParameter("targetId");
                String reason = request.getParameter("reason");
                
                // Kiểm tra null/rỗng để tránh lỗi
                if (reportType != null && targetIdStr != null && reason != null) {
                    int targetId = Integer.parseInt(targetIdStr);
                    
                    // Gọi DAO để lưu báo cáo
                    boolean success = dao.reportViolation(user.getId(), reportType, targetId, reason);
                    
                    if (success) {
                        response.getWriter().write("{\"success\": true}");
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        response.getWriter().write("{\"success\": false}");
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false}");
                }
            }
            // 4. NẾU LÀ TẠO CÂU HỎI MỚI (Mặc định)
            else {
                int bookId = Integer.parseInt(request.getParameter("pid"));
                String title = request.getParameter("discussionTitle");
                String content = request.getParameter("discussionContent");
                String topicTag = request.getParameter("topicTag");
                boolean hasSpoiler = request.getParameter("hasSpoiler") != null;
                // [THÊM MỚI] - XỬ LÝ EX 2: BỘ LỌC TỪ NGỮ CẤM
                if (containsBadWords(title) || containsBadWords(content)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false, \"message\": \"Your comment contains inappropriate language and cannot be posted.\"}");
                    return;
                }

                int newId = dao.createDiscussion(bookId, user.getId(), title, content, hasSpoiler, topicTag);
                if (newId > 0) {
                    response.getWriter().write("{\"success\": true, \"discussionId\": " + newId + "}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false}");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false}");
        }
    }
    // Hàm kiểm tra từ ngữ vi phạm
    private boolean containsBadWords(String text) {
        if (text == null) return false;
        String lowerText = text.toLowerCase();
        // Danh sách từ cấm (Bạn có thể thêm bớt tùy ý)
        String[] badWords = {"đm", "vcl", "fuck", "shit", "ngu", "chó", "dmm"}; 
        for (String word : badWords) {
            if (lowerText.contains(word)) return true;
        }
        return false;
    }
}