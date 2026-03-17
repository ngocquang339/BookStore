package com.group2.bookstore.controller;

import com.group2.bookstore.dal.WarehouseOrderDAO;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.Supplier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CreatePOServlet", urlPatterns = {"/create-po"})
public class CreatePOServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        WarehouseOrderDAO dao = new WarehouseOrderDAO();
        
        // 1. Lấy danh sách đổ ra Dropdown
        List<Supplier> suppliers = dao.getAllActiveSuppliers();
        List<Book> books = dao.getAllActiveBooks();
        
        // 2. Gửi dữ liệu sang JSP
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("books", books);
        
        // 3. Điều hướng
        request.getRequestDispatcher("/view/warehouse/create_purchase_order.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            // 1. Lấy thông tin cơ bản
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            
            // Lấy ID của nhân viên kho đang đăng nhập (Giả lập là 4, bạn nên lấy từ Session)
            // HttpSession session = request.getSession();
            // User loginUser = (User) session.getAttribute("account");
            // int userId = loginUser.getUserId();
            int userId = 4; 
            
            // 2. Lấy danh sách chi tiết (Dạng mảng)
            String statusNote = request.getParameter("statusNote");
            String[] bookIds = request.getParameterValues("bookId[]");
            String[] expectedQuantities = request.getParameterValues("expectedQuantity[]");
            String[] importPrices = request.getParameterValues("importPrice[]");
            
            // 3. Gọi DAO xử lý
            WarehouseOrderDAO dao = new WarehouseOrderDAO();
            boolean isSuccess = dao.createPurchaseOrder(supplierId, userId, statusNote, bookIds, expectedQuantities, importPrices);
            
            if (isSuccess) {
                // Tạo thành công -> Chuyển về trang danh sách PO (View Purchase Order)
                response.sendRedirect("create-po?status=success");
            } else {
                // Thất bại -> Báo lỗi và quay lại trang tạo
                request.setAttribute("error", "Tạo đơn hàng thất bại. Vui lòng thử lại!");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
            doGet(request, response);
        }
    }
}