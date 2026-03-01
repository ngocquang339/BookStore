package com.group2.bookstore.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.CategoryDAO;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.Category;

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
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        BookDAO bookDAO = new BookDAO();
        CategoryDAO catDAO = new CategoryDAO();
        if (path.equals("/admin/product/list")) {
    // 1. Get Search & Sort Params
    String keyword = request.getParameter("keyword");
    String cidRaw = request.getParameter("cid");
    String sortBy = request.getParameter("sortBy");
    if (sortBy == null || sortBy.isEmpty()) sortBy = "book_id";
    String sortOrder = request.getParameter("sortOrder");
    if (sortOrder == null || sortOrder.isEmpty()) sortOrder = "DESC";

    // 2. Process Category ID
    int cid = 0;
    if (cidRaw != null && !cidRaw.equals("all") && !cidRaw.isEmpty()) {
        try { cid = Integer.parseInt(cidRaw); } catch (NumberFormatException e) { cid = 0; }
    }

    // 3. Pagination Logic
    int index = 1; // Default to page 1
    String indexParam = request.getParameter("index");
    if (indexParam != null && !indexParam.isEmpty()) {
        try { index = Integer.parseInt(indexParam); } catch (NumberFormatException e) {}
    }
    int pageSize = 10; // Books per page

    // Count total books to calculate endPage
    int totalBooks = bookDAO.countBooks(keyword, cid, true);
    int endPage = totalBooks / pageSize;
    if (totalBooks % pageSize != 0) {
        endPage++;
    }

    // 4. Fetch the Data
    List<Book> list = bookDAO.getBooks(keyword, cid, null, null, 0, 0, sortBy, sortOrder, true, index, pageSize);
    List<Category> categories = catDAO.getCategories();

    // 5. Send data to JSP
    request.setAttribute("listBooks", list);
    request.setAttribute("listCategories", categories);
    
    // Send form and pagination states
    request.setAttribute("searchKeyword", keyword);
    request.setAttribute("searchCid", cidRaw);
    request.setAttribute("sortBy", sortBy);
    request.setAttribute("sortOrder", sortOrder);
    request.setAttribute("tag", index); // Current page
    request.setAttribute("endPage", endPage); // Total pages

            // 7. Get Data for Current Page
            

            // 8. Send Data to JSP
            request.setAttribute("listBooks", list);
            request.setAttribute("listCategories", categories);
            request.setAttribute("endPage", endPage);
            request.setAttribute("tag", index);

            // Send back filters so they stick in the URL/Search bar
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("searchCid", cidRaw);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);

            request.getRequestDispatcher("/view/admin/manage-products.jsp").forward(request, response);
        }
        CategoryDAO catDao = new CategoryDAO();
        request.setAttribute("listCategories", catDao.getCategories());
    request.getRequestDispatcher("/view/admin/manage-products.jsp").forward(request, response);

        if (path.equals("/admin/product/add")) {
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> listC = categoryDAO.getCategories();
            request.setAttribute("listCategories", listC);
            request.getRequestDispatcher("/view/admin/product-form.jsp").forward(request, response);
        } else if (path.equals("/admin/product/edit")) {
            // Inside your doGet method for "edit" or "load"

            CategoryDAO categoryDAO = new CategoryDAO(); // 1. Instantiate CategoryDAO

            int id = Integer.parseInt(request.getParameter("id"));
            Book b = bookDAO.getBookById(id);

            List<Category> listC = categoryDAO.getCategories();

            request.setAttribute("book", b);
            request.setAttribute("listCategories", listC); // 3. Send the list to JSP

            request.getRequestDispatcher("/view/admin/product-form.jsp").forward(request, response);
        } else if (path.equals("/admin/product/delete")) {
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
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
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
