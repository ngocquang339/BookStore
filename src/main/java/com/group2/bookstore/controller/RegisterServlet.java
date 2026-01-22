package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = { "/register" })
public class RegisterServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/Register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        String e = request.getParameter("email");
        String re_p = request.getParameter("re_pass");

        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty()) {
            // Xử lý lỗi: Chuyển hướng lại trang login và báo lỗi
            request.setAttribute("mess", "Không được để trống thông tin!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        if (re_p != null && !p.equals(re_p)) {
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("view/Register.jsp").forward(request, response);
            return;
        }

        UserDAO userdao = new UserDAO();
        User us = userdao.checkUserExist(u);

        if(us == null){
            User newuser = new User();
            newuser.setUsername(u);
            newuser.setEmail(e);
            newuser.setPassword(p);
            userdao.createUser(newuser);
            response.sendRedirect("login");
            return;
        }
        else{
            request.setAttribute("mess", "Tên đăng nhập đã tồn tại");
            request.getRequestDispatcher("view/Register.jsp").forward(request, response);
        }
    }
}
