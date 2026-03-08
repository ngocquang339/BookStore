package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.ReturnRequestDAO;
import com.group2.bookstore.model.ReturnRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ManageReturnsServlet", urlPatterns = {"/admin/returns"})
public class ManageReturnsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ReturnRequestDAO dao = new ReturnRequestDAO();
        List<ReturnRequest> returnList = dao.getAllReturns();
        
        request.setAttribute("returnList", returnList);
        request.getRequestDispatcher("/view/admin/manage-returns.jsp").forward(request, response);
    }
}