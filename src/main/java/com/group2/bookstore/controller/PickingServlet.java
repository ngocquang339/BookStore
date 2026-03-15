package com.group2.bookstore.controller;

import com.group2.bookstore.dal.WarehouseOrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/warehouse/picking")
public class PickingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        WarehouseOrderDAO dao = new WarehouseOrderDAO();

        request.setAttribute("orderInfo", dao.getOrderCustomerInfo(orderId));
        request.setAttribute("pickingItems", dao.getOrderDetails(orderId));
        request.setAttribute("orderId", orderId);

        request.getRequestDispatcher("/view/warehouse/picking_list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        WarehouseOrderDAO dao = new WarehouseOrderDAO();

        try {

            dao.confirmPicking(orderId);

            request.getSession().setAttribute(
                    "successMessage",
                    "Picking completed successfully!"
            );

        } catch (Exception e) {

            request.getSession().setAttribute(
                    "errorMessage",
                    e.getMessage()
            );
        }

        response.sendRedirect(request.getContextPath() + "/warehouse/orders");
    }
}
