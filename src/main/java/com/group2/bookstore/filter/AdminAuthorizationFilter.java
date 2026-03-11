package com.group2.bookstore.filter;

import java.io.IOException; 

import com.group2.bookstore.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Protects all URLs starting with /admin/
@WebFilter(filterName = "AdminAuthorizationFilter", urlPatterns = {"/admin/*"})
public class AdminAuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean isAdmin = false;

        // 1. Check if session exists and the "user" object is in it (Matches LoginServlet)
        if (session != null && session.getAttribute("user") != null) {
            
            // 2. Extract the User object
            User loggedInUser = (User) session.getAttribute("user");
            
            // 3. Check if they have Role == 1 (Matches LoginServlet)
            if (loggedInUser.getRole() == 1) { 
                isAdmin = true;
            }
        }

        // 4. The Bouncer's Decision
        if (isAdmin) {
            // Access Granted! Let them through.
            chain.doFilter(request, response);
        } else {
            // Access Denied! Redirect to login.
            // Using absolute path context to prevent infinite redirect loops
            res.sendRedirect(req.getContextPath() + "/login"); 
        }
    }

    @Override
    public void destroy() {}
}