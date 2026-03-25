package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.group2.bookstore.dal.PurchaseOrderDAO;
import com.group2.bookstore.model.PurchaseOrderDetail;
import com.group2.bookstore.model.User; // Thêm import User

@WebServlet("/warehouse/receive-goods")
public class ReceiveGoodsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String poIdParam = request.getParameter("poId");
        if (poIdParam == null || poIdParam.isEmpty()) {
            response.sendRedirect("view-po");
            return;
        }

        try {
            int poId = Integer.parseInt(poIdParam);
            PurchaseOrderDAO dao = new PurchaseOrderDAO();
            
            // Lấy danh sách dùng Model PurchaseOrderDetail
            List<PurchaseOrderDetail> receiveList = dao.getPoDetailsForReceive(poId);
            
            request.setAttribute("poId", poId);
            request.setAttribute("receiveList", receiveList);
            request.getRequestDispatcher("/view/warehouse/receive_list.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("view-po");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String poIdParam = request.getParameter("poId");
        String[] selectedBooks = request.getParameterValues("selectedBooks");

        if (poIdParam != null && selectedBooks != null && selectedBooks.length > 0) {
            try {
                int poId = Integer.parseInt(poIdParam);
                PurchaseOrderDAO dao = new PurchaseOrderDAO();
                
                // ================= LẤY USER ID TỪ SESSION =================
                // (Nhớ đổi "account" thành key thực tế bạn dùng lưu session lúc đăng nhập nếu khác nhé)
                User loginUser = (User) request.getSession().getAttribute("user"); // ĐÚNG
                
                if (loginUser != null) {
                    int userId = loginUser.getId();
                    
                    // Thực thi Transaction cộng kho, đổi trạng thái, ghi log VÀ tạo hóa đơn
                    boolean success = dao.confirmReceive(poId, selectedBooks, userId);
                    
                    if (success) {
                        // Về lại trang danh sách PO (có thể bắt param msg để hiện alert toastr nếu muốn)
                        response.sendRedirect("view-po?msg=receive_success");
                        return;
                    }
                } else {
                    // Xử lý rủi ro nếu người dùng mất session (hết hạn đăng nhập)
                    response.sendRedirect(request.getContextPath() + "/login?msg=session_expired");
                    return;
                }
                // ==========================================================
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("view-po?msg=receive_fail");
    }
}