package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// Cấu hình Servlet này "bắt" nhiều đường dẫn cùng lúc
@WebServlet(name = "PolicyServlet", urlPatterns = {
        "/terms",
        "/privacy",
        "/payment-policy",
        "/shipping-policy",
        "/return-policy"
})
public class PolicyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy ra đường dẫn hiện tại mà người dùng vừa click vào
        String path = request.getServletPath();
        String jspPage = "";
        switch (path) {
            case "/terms":
                // Đã trỏ đường dẫn vào thư mục Footer
                jspPage = "/view/footer/TermsOfUse.jsp";
                break;
            case "/privacy":
                jspPage = "/view/footer/PrivacyPolicy.jsp";
                break;
            case "/payment-policy":
                jspPage = "/view/footer/PaymentPolicy.jsp";
                break;
            case "/shipping-policy":
                jspPage = "/view/footer/ShippingPolicy.jsp";
                break;
            case "/return-policy":
                jspPage = "/view/footer/ReturnPolicy.jsp";
                break;
            default:
                jspPage = "/view/footer/TermsOfUse.jsp";
                break;
        }

        // Chuyển hướng (Forward) request tới file JSP tương ứng
        request.getRequestDispatcher(jspPage).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đối với các trang chính sách chỉ xem thông tin, ta đẩy Post về Get luôn
        doGet(request, response);
    }
}