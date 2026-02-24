package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.CartItem;
import com.group2.bookstore.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    // GET: Hiển thị trang điền thông tin thanh toán
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        // Kiểm tra nếu giỏ hàng trống thì không cho vào trang thanh toán
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect("cart");
            return;
        }

        // 2.Tính tổng tiền để hiển thị tóm tắt trên trang checkout
        double total = 0;
        for (CartItem item : cart) {
            total += item.getTotalPrice();
        }
        req.setAttribute("grandTotal", total);
        req.getRequestDispatcher("view/checkout.jsp").forward(req, resp);
    }

    // POST: Xử lý khi người dùng nhấn nút "Xác nhận đặt hàng"
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        // Thiết lập tiếng Việt cho dữ liệu từ Form
        req.setCharacterEncoding("UTF-8");
        HttpSession session= req.getSession();
        User user=(User) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart"); 
        
        // Kiểm tra đăng nhập
        if(user != null && cart !=null && !cart.isEmpty()){
          

        // Lấy thông tin từ Form Checkout
        String fullname=req.getParameter("fullname").trim();
        String phone=req.getParameter("phone").trim();
        String address=req.getParameter("address").trim();
        String paymentMethod=req.getParameter("paymentMethod");
        double total=0;
        // 1. Kiểm tra họ tên: Không chứa số (Regex)
        if (!fullname.matches("^[a-zA-ZÀ-ỹ\\s]+$")) {
        req.setAttribute("error", "Họ tên chỉ được phép chứa chữ cái!");
    // Quay lại trang checkout kèm thông báo lỗi
        req.getRequestDispatcher("view/checkout.jsp").forward(req, resp);
        return;
}

    // 2. Kiểm tra số điện thoại: Phải là 10 chữ số
        if (!phone.matches("0[0-9]{9}")) {
        req.setAttribute("error", "Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0!");
        req.getRequestDispatcher("view/checkout.jsp").forward(req, resp);
        return;
}
        for(CartItem item: cart){
            total+=item.getTotalPrice();
        }
        OrderDAO dao=new OrderDAO();
        dao.createOrder(user, cart, address, phone, total, paymentMethod);
        // Xóa sạch dữ liệu trên session (Đòng bộ với DB)
        session.removeAttribute("cart");
        session.removeAttribute("totalItems");
        session.setAttribute("message", "Đặt hàng thành công!");
        session.setAttribute("messageType", "success");
        resp.sendRedirect("home");
        
    }
    else {
        resp.sendRedirect("cart");
    }
}
}
