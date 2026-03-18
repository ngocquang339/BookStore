package com.group2.bookstore.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
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
            if (sortBy == null || sortBy.isEmpty()) {
                sortBy = "book_id";
            }
            String sortOrder = request.getParameter("sortOrder");
            if (sortOrder == null || sortOrder.isEmpty()) {
                sortOrder = "DESC";
            }

            // 2. Process Category ID
            int cid = 0;
            if (cidRaw != null && !cidRaw.equals("all") && !cidRaw.isEmpty()) {
                try {
                    cid = Integer.parseInt(cidRaw);
                } catch (NumberFormatException e) {
                    cid = 0;
                }
            }

            // 3. Pagination Logic
            int index = 1; // Default to page 1
            String indexParam = request.getParameter("index");
            if (indexParam != null && !indexParam.isEmpty()) {
                try {
                    index = Integer.parseInt(indexParam);
                } catch (NumberFormatException e) {
                }
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
            List<Category> categories = catDAO.getAllCategories();

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

            request.getRequestDispatcher("/view/admin/manage-products.jsp").forward(request, response);
        }

        if (path.equals("/admin/product/add")) {
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> listC = categoryDAO.getAllCategories();
            request.setAttribute("listCategories", listC);
            request.getRequestDispatcher("/view/admin/product-form.jsp").forward(request, response);
        } else if (path.equals("/admin/product/edit")) {
            // Inside your doGet method for "edit" or "load"

            CategoryDAO categoryDAO = new CategoryDAO(); // 1. Instantiate CategoryDAO

            int id = Integer.parseInt(request.getParameter("id"));
            Book b = bookDAO.getBookById(id);

            List<Category> listC = categoryDAO.getAllCategories();

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
        int quantity = Integer.parseInt(request.getParameter("stockQuantity"));
        String supplier = request.getParameter("supplier");
        int numberPage = request.getParameter("numberPage") != null && !request.getParameter("numberPage").isEmpty() ? Integer.parseInt(request.getParameter("numberPage")) : 0;
        int yearOfPublish = request.getParameter("yearOfPublish") != null && !request.getParameter("yearOfPublish").isEmpty() ? Integer.parseInt(request.getParameter("yearOfPublish")) : 0;
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
            b.setSupplier(supplier);
            b.setNumberPage(numberPage);
            b.setYearOfPublish(yearOfPublish);

            request.setAttribute("book", b);
            // --- FIX ENDS HERE ---

            request.getRequestDispatcher("/view/admin/product-form.jsp").forward(request, response);
            return;
        }
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String desc = request.getParameter("description");
        boolean isActive = request.getParameter("active") != null;

        // 2. Handle Image Upload
        Part filePart = request.getPart("imageFile");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        String finalImageName = "";

        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = "E:\\bookstore_data\\image\\books";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // --- THE BULLETPROOF COPY METHOD ---
            // Extract the raw data stream from the uploaded file
            try (InputStream fileContent = filePart.getInputStream()) {
                // Force Java to save it to your E: drive, replacing any existing file with the same name
                Files.copy(fileContent, Paths.get(uploadPath, fileName), StandardCopyOption.REPLACE_EXISTING);
                System.out.println("SUCCESS: Saved uploaded file to " + uploadPath + "\\" + fileName);
            } catch (Exception e) {
                System.out.println("FAILED to save image file!");
                e.printStackTrace();
            }

            // Format the name for the database (Adjust this if your DB expects "assets/image/books/...")
            finalImageName = "assets/image/books/" + fileName;
        } else {
            // Keep the old image if nothing was uploaded
            finalImageName = request.getParameter("currentImage");
        }

        // 3. Prepare Book Object safely
        String action = request.getParameter("action");
        System.out.println("--- DEBUG: STARTING POST REQUEST ---");
        System.out.println("ACTION: " + action);

        Book b;
        if (!"add".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            System.out.println("EDITING BOOK ID: " + id);
            b = dao.getBookById(id);
            System.out.println("OLD CATEGORY ID IN DB: " + b.getCategoryId());
        } else {
            b = new Book();
        }

        // Update the fields
        b.setTitle(title);
        b.setAuthor(author);
        b.setPrice(price);
        b.setImportPrice(importPrice);
        b.setStockQuantity(quantity);

        // Let's see exactly what the HTML form sent us!
        System.out.println("NEW CATEGORY ID FROM FORM: " + categoryId);
        b.setCategoryId(categoryId);

        b.setDescription(desc);
        b.setActive(isActive);
        b.setImageUrl(finalImageName);

        if (request.getParameter("publisher") != null) {
            b.setPublisher(request.getParameter("publisher"));
        }
        if (request.getParameter("supplier") != null) {
            b.setSupplier(request.getParameter("supplier"));
        }
        if (request.getParameter("yearOfPublish") != null && !request.getParameter("yearOfPublish").isEmpty()) {
            b.setYearOfPublish(Integer.parseInt(request.getParameter("yearOfPublish")));
        }
        if (request.getParameter("numberPage") != null && !request.getParameter("numberPage").isEmpty()) {
            b.setNumberPage(Integer.parseInt(request.getParameter("numberPage")));
        }

        // 4. Save Main Book to DB
        int currentBookId = 0;
        try {
            if ("add".equals(action)) {
                // IMPORTANT: Your insertBook method MUST retrieve the generated ID
                // and set it back into 'b' (e.g., b.setId(generatedKey))

                currentBookId = dao.insertBook(b);
                System.out.println("SUCCESS: Inserted new book ID " + currentBookId);
            } else {
                currentBookId = Integer.parseInt(request.getParameter("id"));
                b.setId(currentBookId);
                dao.updateBook(b);
                System.out.println("SUCCESS: Updated book ID " + currentBookId);
            }

            // ==========================================
            // 5. HANDLE SELECTIVE DELETIONS
            // ==========================================
            String[] imagesToDelete = request.getParameterValues("deleteImageIds");
            if (imagesToDelete != null) {
                for (String imgIdStr : imagesToDelete) {
                    try {
                        int imageId = Integer.parseInt(imgIdStr);
                        dao.deleteDetailImageById(imageId); // Remove from DB
                        System.out.println("SUCCESS: Deleted image ID " + imageId);
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }
                }
            }

            // ==========================================
            // 6. ADD NEW DETAIL IMAGES (Without wiping the old ones)
            // ==========================================
            boolean hasNewDetails = false;
            for (Part part : request.getParts()) {
                if ("detailImages".equals(part.getName()) && part.getSize() > 0) {
                    hasNewDetails = true;
                    break;
                }
            }

            if (hasNewDetails) {
                // 🚨 NOTICE: We REMOVED the dao.deleteDetailImages(currentBookId) line here! 
                // Now it just adds to the gallery instead of replacing it.

                String detailUploadPath = "E:\\bookstore_data\\image\\details";
                File detailDir = new File(detailUploadPath);
                if (!detailDir.exists()) {
                    detailDir.mkdirs();
                }

                // Loop through all uploaded files
                for (Part part : request.getParts()) {
                    if ("detailImages".equals(part.getName()) && part.getSize() > 0) {
                        String detailFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

                        try (InputStream fileContent = part.getInputStream()) {
                            Files.copy(fileContent, Paths.get(detailUploadPath, detailFileName), StandardCopyOption.REPLACE_EXISTING);

                            String finalDetailPath = "assets/image/details/" + detailFileName;
                            dao.insertDetailImage(currentBookId, finalDetailPath);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
            // ==========================================

        } catch (Exception e) {
            System.out.println("CRITICAL DB ERROR DURING SAVE:");
            e.printStackTrace();
        }

        System.out.println("--- DEBUG: REDIRECTING TO DASHBOARD ---");
        response.sendRedirect(request.getContextPath() + "/admin/product/list");
    }
}
