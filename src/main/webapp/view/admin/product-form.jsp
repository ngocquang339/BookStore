<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <title>${book != null ? 'Edit Book' : 'Add New Book'}</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .form-container {
                    max-width: 800px;
                    margin: 40px auto;
                    padding: 30px;
                    background: white;
                    border-radius: 8px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                }

                .form-group {
                    margin-bottom: 20px;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: bold;
                    color: #333;
                }

                .form-group input,
                .form-group select,
                .form-group textarea {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    box-sizing: border-box;
                }

                .form-row {
                    display: flex;
                    gap: 20px;
                }

                .form-row .form-group {
                    flex: 1;
                }

                .btn-submit {
                    background-color: #28a745;
                    color: white;
                    padding: 12px 24px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 16px;
                    font-weight: bold;
                }

                .btn-submit:hover {
                    background-color: #218838;
                }

                .btn-cancel {
                    margin-left: 10px;
                    color: #666;
                    text-decoration: none;
                }

                .preview-img {
                    margin-top: 10px;
                    border: 1px solid #ddd;
                    padding: 5px;
                    border-radius: 4px;
                }
            </style>
        </head>

        <body>

            <div class="form-container">
                <h2 style="margin-top: 0; border-bottom: 2px solid #f0f0f0; padding-bottom: 15px; margin-bottom: 20px;">
                    <i class="fa-solid fa-pen-to-square"></i> ${book != null ? 'Edit Book' : 'Add New Book'}
                </h2>

                <form action="${pageContext.request.contextPath}/admin/product/${book != null ? 'edit' : 'add'}"
                    method="post" enctype="multipart/form-data">

                    <input type="hidden" name="action" value="${book != null ? 'edit' : 'add'}">

                    <c:if test="${book != null}">
                        <input type="hidden" name="id" value="${book.id}">
                        <input type="hidden" name="currentImage" value="${book.image}">
                    </c:if>

                    <div class="form-group">
                        <label>Book Title</label>
                        <input type="text" name="title" value="${book.title}" required placeholder="Enter book name...">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Author</label>
                            <input type="text" name="author" value="${book.author}" required>
                        </div>
                        <div class="form-group">
                            <label>Category</label>
                            <select name="categoryId">
                                <c:forEach items="${listCategories}" var="c">
                                    <option value="${c.id}" ${book.categoryId==c.id ? 'selected' : '' }>${c.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group" style="flex: 1;">
                            <label>Selling Price ($):</label>
                            <input type="number" step="0.01" min="0.01" name="price" value="${book.price}" required>
                        </div>

                        <div class="form-group" style="flex: 1;">
                            <label>Import Price ($) [Admin Only]:</label>
                            <input type="number" step="0.01" min="0.01" name="importPrice" value="${book.importPrice}"
                                required>
                        </div>

                        <div class="form-group">
                            <label>Stock Quantity:</label>
                            <input type="number" min="0" name="quantity" value="${book.stockQuantity}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Book Cover Image</label>
                        <c:if test="${not empty book.image}">
                            <div style="margin-bottom: 10px;">
                                <img src="${pageContext.request.contextPath}/assets/image/${book.image}" height="100"
                                    class="preview-img">
                                <br><small>Current image: ${book.image}</small>
                            </div>
                        </c:if>
                        <input type="file" name="imageFile" accept="image/*" ${book==null ? 'required' : '' }>
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" rows="5" required>${book.description}</textarea>
                    </div>

                    <div class="form-group">
                        <label style="cursor: pointer; display: inline-flex; align-items: center;">
                            <input type="checkbox" name="active" value="true" ${book==null || book.active ? 'checked'
                                : '' } style="width: auto; margin-right: 10px;">
                            Is Active (Visible on Shop)
                        </label>
                    </div>

                    <div style="text-align: right;">
                        <a href="${pageContext.request.contextPath}/admin/product/list" class="btn-cancel">Cancel</a>
                        <button type="submit" class="btn-submit"><i class="fa-solid fa-save"></i> Save Book</button>
                    </div>
                </form>
            </div>

        </body>

        </html>