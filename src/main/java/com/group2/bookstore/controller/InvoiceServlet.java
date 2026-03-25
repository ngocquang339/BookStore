package com.group2.bookstore.controller;

import com.group2.bookstore.dal.InvoiceDAO;
import com.group2.bookstore.model.Invoice;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/warehouse/invoices"})
public class InvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        String filter = request.getParameter("filter"); // Lấy tham số bộ lọc
        InvoiceDAO dao = new InvoiceDAO();

        try {
            // 1. Lấy danh sách hóa đơn có kèm bộ lọc
            List<Invoice> invoices = dao.getAllInvoices(filter);
            request.setAttribute("invoices", invoices);
            request.setAttribute("currentFilter", filter); // Giữ lại trạng thái lọc trên giao diện

            // 2. Xử lý khi click "View Detail"
            if ("detail".equals(action)) {
                String idParam = request.getParameter("id");
                String type = request.getParameter("type"); 

                if (idParam != null && !idParam.isEmpty() && type != null && !type.isEmpty()) {
                    int invoiceId = Integer.parseInt(idParam);
                    Map<String, Object> invoiceDetail = null;
                    
                    if ("SALE".equals(type.toUpperCase())) {
                        invoiceDetail = dao.getSaleInvoiceDetail(invoiceId);
                        request.setAttribute("type", "SALE");
                    } else if ("PURCHASE".equals(type.toUpperCase())) {
                        invoiceDetail = dao.getPurchaseInvoiceDetail(invoiceId);
                        request.setAttribute("type", "PURCHASE");
                    }

                    if (invoiceDetail == null) {
                        request.setAttribute("errorMessage", "Không tìm thấy hóa đơn!");
                    } else {
                        request.setAttribute("invoiceDetail", invoiceDetail);
                        request.setAttribute("openModal", true); 
                    }
                }
            }

            request.getRequestDispatcher("/view/warehouse/invoice_list.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID hóa đơn không hợp lệ!");
            request.getRequestDispatcher("/view/warehouse/invoice_list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý hệ thống hóa đơn.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}