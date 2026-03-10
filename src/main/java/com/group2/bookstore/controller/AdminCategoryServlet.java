package com.group2.bookstore.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import com.group2.bookstore.dal.CategoryDAO;
import com.group2.bookstore.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = {
    "/admin/category/add",
    "/admin/categories",
    "/admin/category/edit",
    "/admin/category/delete" // Add this new pattern
})

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Always provide the list for the dropdowns or the table
        request.setAttribute("listCategories", categoryDAO.getAllCategories());

        if (path.equals("/admin/categories")) {
            request.getRequestDispatcher("/view/admin/manage-categories.jsp").forward(request, response);
        } else if (path.equals("/admin/category/edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Category c = categoryDAO.getCategoryById(id);
            request.setAttribute("category", c); // This is what fills the form!
            request.getRequestDispatcher("/view/admin/category-form.jsp").forward(request, response);
        } else if (path.equals("/admin/category/add")) {
            request.getRequestDispatcher("/view/admin/category-form.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        CategoryDAO dao = new CategoryDAO();

        // 1. Handle Delete immediately and return
        if (path.equals("/admin/category/delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.hasBooks(id) || dao.hasChildren(id)) {
                response.sendRedirect(request.getContextPath() + "/admin/categories?error=dependency");
            } else {
                dao.deleteCategory(id);
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=deleted");
            }
            return; // Stop processing
        }

        // 2. Collect Common Data for Add/Edit
        String name = request.getParameter("categoryName");
        String desc = request.getParameter("description");
        String parentIdRaw = request.getParameter("parentId");

        Category c = new Category();
        c.setName(name);
        c.setDescription(desc);

        if (parentIdRaw != null && !parentIdRaw.isEmpty()) {
            c.setParentId(Integer.parseInt(parentIdRaw));
        } else {
            c.setParentId(null);
        }

        // --- UPDATED: Handle Image Upload with Unique Names ---
        Part filePart = request.getPart("imageFile");
        String fileName = "";
        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Add a timestamp to the filename to avoid "File in use" errors
            // Example: Nuoidaycon.jpg -> 17156382910_Nuoidaycon.jpg
            fileName = System.currentTimeMillis() + "_" + originalFileName;
        }

        String finalImageName = "";
        if (!fileName.isEmpty()) {
            String uploadPath = "E:\\bookstore_data\\image\\categories";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            try (InputStream fileContent = filePart.getInputStream()) {
                // Since the filename is unique, REPLACE_EXISTING won't fail due to locks!
                Files.copy(fileContent, Paths.get(uploadPath, fileName), StandardCopyOption.REPLACE_EXISTING);
                finalImageName = "assets/image/Categories/" + fileName;
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            finalImageName = request.getParameter("currentImage");
        }
        c.setImageUrl(finalImageName); // Pass it to the object!
        // --------------------------------

        // 3. Differentiate between Insert and Update
        if (path.equals("/admin/category/edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            c.setId(id);
            dao.updateCategory(c);
        } else {
            dao.insertCategory(c);
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
