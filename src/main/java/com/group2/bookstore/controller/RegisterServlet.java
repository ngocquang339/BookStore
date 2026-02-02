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
        String fn = request.getParameter("fullname");
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        String e = request.getParameter("email");
        String phone = request.getParameter("phone_number");
        String re_p = request.getParameter("re_pass");

        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty() || e.length() > 100 || phone == null || phone.trim().isEmpty() || fn == null || fn.trim().isEmpty()){
            request.setAttribute("mess", "Thông tin không hợp lệ!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        if (!e.contains("@")) {
            request.setAttribute("mess", "Email không hợp lệ (phải chứa ký tự @)!");
            request.getRequestDispatcher("view/Register.jsp").forward(request, response);
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
