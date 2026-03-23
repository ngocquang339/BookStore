package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AboutUsServlet", urlPatterns = {"/about-us"})
public class AboutUsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Điều hướng chuẩn MVC tới trang giao diện Giới thiệu
        request.getRequestDispatcher("view/footer/about-us.jsp").forward(request, response);
    }
}