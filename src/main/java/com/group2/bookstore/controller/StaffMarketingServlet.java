package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.util.EmailUtility;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffMarketingServlet", urlPatterns = { "/staff/send-marketing" })
public class StaffMarketingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String targetGroup = request.getParameter("targetGroup");
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");

        if (targetGroup == null || subject == null || content == null
                || targetGroup.trim().isEmpty() || subject.trim().isEmpty() || content.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/customers?marketingResult=" +
                    java.net.URLEncoder.encode("Vui lòng nhập đủ thông tin chiến dịch!", "UTF-8"));
            return;
        }

        UserDAO dao = new UserDAO();
        List<String> recipients = dao.getMarketingEmails(targetGroup);

        int sent = 0;
        int failed = 0;

        for (String email : recipients) {
            try {
                EmailUtility.sendMarketingEmail(email, subject, content);
                sent++;
            } catch (Exception e) {
                failed++;
                e.printStackTrace();
            }
        }

        String resultMsg = "Gửi mail xong: " + sent + " thành công";
        if (failed > 0) {
            resultMsg += ", " + failed + " thất bại";
        }

        response.sendRedirect(request.getContextPath() + "/staff/customers?marketingResult=" +
                java.net.URLEncoder.encode(resultMsg, "UTF-8"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
