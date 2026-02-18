package com.group2.bookstore.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.CategoryDAO;
import com.group2.bookstore.model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/product/list", "/admin/product/add", "/admin/product/edit", "/admin/product/delete"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.equals("/admin/product/list")) {
            BookDAO dao = new BookDAO();
            List<Book> list = dao.getAllBooksForAdmin();
            // Debugging: Print to console to see if it works
            System.out.println("Books found: " + list.size());
            request.setAttribute("listBooks", list);
            request.getRequestDispatcher("/view/admin/manage-products.jsp").forward(request, response);
            return; // Stop here
        }
        CategoryDAO catDao = new CategoryDAO();
        request.setAttribute("listCategories", catDao.getCategories());

        if (path.equals("/admin/product/add")) {
            request.getRequestDispatcher("/view/admin/product-form.jsp").forward(request, response);
        } 
        else if (path.equals("/admin/product/edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            BookDAO bookDao = new BookDAO();
            Book b = bookDao.getBookById(id);
            request.setAttribute("book", b);
            request.getRequestDispatcher("/view/admin/product-form.jsp").forward(request, response);
        }
        else if (path.equals("/admin/product/delete")) {
            // SOFT DELETE Logic
            int id = Integer.parseInt(request.getParameter("id"));
            BookDAO bookDao = new BookDAO();
            bookDao.softDeleteBook(id);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        BookDAO dao = new BookDAO();
        
        // 1. Collect Form Data
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        double price = Double.parseDouble(request.getParameter("price"));
        double importPrice = Double.parseDouble(request.getParameter("importPrice"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        // ... inside the validation block ...

    if (price <= 0 || importPrice <= 0 || quantity < 0) {
        request.setAttribute("error", "Prices must be greater than 0 and Quantity cannot be negative.");
        
        // --- FIX STARTS HERE ---
        // Create a temporary Book object to preserve user input
        Book b = new Book();
        b.setId(0); // ID doesn't matter for a failed add
        b.setTitle(title);
        b.setAuthor(author);
        b.setPrice(price);
        b.setImportPrice(importPrice);
        b.setStockQuantity(quantity);
        b.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        b.setDescription(request.getParameter("description"));
        b.setActive(request.getParameter("active") != null);
        b.setImageUrl(request.getParameter("currentImage")); // Keep the old image if valid
        
        request.setAttribute("book", b);
        // --- FIX ENDS HERE ---

        request.getRequestDispatcher("/view/admin/product-form.jsp").forward(request, response);
        return; 
    }
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String desc = request.getParameter("description");
        boolean isActive = request.getParameter("active") != null;

        // 2. Handle Image Upload
        Part filePart = request.getPart("imageFile"); // Matches <input type="file" name="imageFile">
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        
        // If user didn't upload a new file, keep the old one (for Edit mode)
        String finalImageName = fileName;
        if (fileName == null || fileName.isEmpty()) {
            finalImageName = request.getParameter("currentImage");
        } else {
            // Save file to server
            String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "image" + File.separator + "books";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
        }

        // 3. Create Book Object
        Book b = new Book();
        b.setTitle(title);
        b.setAuthor(author);
        b.setPrice(price);
        b.setImportPrice(importPrice);
        b.setStockQuantity(quantity);
        b.setCategoryId(categoryId);
        b.setDescription(desc);
        b.setActive(isActive);
        b.setImageUrl(finalImageName);

        // 4. Save to DB
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            dao.insertBook(b);
        } else {
            int id = Integer.parseInt(request.getParameter("id"));
            b.setId(id);
            dao.updateBook(b);
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}