package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CustomerDetailServlet", urlPatterns = { "/staff/customer-detail" })
public class CustomerDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        try {
            int id = Integer.parseInt(idRaw);
            UserDAO dao = new UserDAO();
            User customer = dao.getUserById(id);

            String ajax = request.getParameter("ajax");
            if ("1".equals(ajax) || "true".equalsIgnoreCase(ajax)) {
                response.setContentType("application/json;charset=UTF-8");
                try (java.io.PrintWriter out = response.getWriter()) {
                    if (customer == null) {
                        out.print("{\"error\":\"Customer not found\"}");
                        return;
                    }
                    java.util.List<com.group2.bookstore.model.CustomerNote> notes = dao.getCustomerNotes(id);
                    StringBuilder json = new StringBuilder();
                    json.append('{');
                    json.append("\"customer\":{");
                    json.append("\"id\":"+customer.getId()+",");
                    json.append("\"username\":\""+escapeJson(customer.getUsername())+"\",");
                    json.append("\"fullname\":\""+escapeJson(customer.getFullname())+"\",");
                    json.append("\"email\":\""+escapeJson(customer.getEmail())+"\",");
                    json.append("\"phone_number\":\""+escapeJson(customer.getPhone_number())+"\",");
                    json.append("\"tags\":\""+escapeJson(customer.getTags())+"\",");
                    json.append("\"status\":"+customer.getStatus());
                    json.append("},");
                    json.append("\"notes\":[");
                    for (int i = 0; i < notes.size(); i++) {
                        com.group2.bookstore.model.CustomerNote n = notes.get(i);
                        json.append('{');
                        json.append("\"contactChannel\":\""+escapeJson(n.getContactChannel())+"\",");
                        json.append("\"noteContent\":\""+escapeJson(n.getNoteContent())+"\",");
                        json.append("\"followUpDate\":\""+(n.getFollowUpDate()!=null ? n.getFollowUpDate().toString() : "")+"\",");
                        json.append("\"createAt\":\""+(n.getCreateAt()!=null ? n.getCreateAt().toString() : "")+"\"");
                        json.append('}');
                        if (i < notes.size()-1) json.append(',');
                    }
                    json.append(']');
                    json.append('}');
                    out.print(json.toString());
                    return;
                }
            }

            if (customer != null) {
                java.util.List<com.group2.bookstore.model.CustomerNote> notes = dao.getCustomerNotes(id);
                request.setAttribute("notes", notes);
                // Đẩy dữ liệu sang JSP
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("/view/staff/customer-detail.jsp").forward(request, response);
            } else {
                // ID không tồn tại -> Đá về danh sách
                response.sendRedirect(request.getContextPath() + "/staff/customers");
            }
        } catch (Exception e) {
            // Lỗi linh tinh (gõ sai URL) -> Đá về danh sách
            response.sendRedirect(request.getContextPath() + "/staff/customers");
        }
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}