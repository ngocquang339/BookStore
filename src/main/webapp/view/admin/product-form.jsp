<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <title>${book != null ? 'Edit Book' : 'Add New Book'}</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-form.css?v=1">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        </head>

        <body>

            <div class="form-container">
                <h2>
                    <i class="fa-solid fa-pen-to-square"></i> ${book != null ? 'Edit Book' : 'Add New Book'}
                </h2>





                <form action="${pageContext.request.contextPath}/admin/product/${book != null ? 'edit' : 'add'}"
                    method="post" enctype="multipart/form-data">

                    <input type="hidden" name="action" value="${book != null ? 'edit' : 'add'}">

                    <c:if test="${book != null}">
                        <input type="hidden" name="id" value="${book.id}">
                        <input type="hidden" name="currentImage" value="${book.imageUrl}">
                    </c:if>

                    <div class="form-group">
                        <label>Book Title <span style="color:red">*</span></label>
                        <input type="text" class="form-control" name="title" value="${book.title}" required
                            maxlength="255" placeholder="Enter book name (Max 255 chars)">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Author <span style="color:red">*</span></label>
                            <input type="text" class="form-control" name="author" value="${book.author}" required
                                maxlength="100">
                        </div>
                        <div class="form-group">
                            <label>Category</label>
                            <select class="form-control" name="categoryId">
                                <c:forEach items="${listCategories}" var="c">
                                    <option value="${c.id}" ${book.categoryId==c.id ? 'selected' : '' }>${c.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Selling Price (đ) <span style="color:red">*</span></label>
                            <input type="number" class="form-control" step="0.01" min="0.01" name="price"
                                id="sellingPrice" value="${book.price}" required oninput="checkPriceGap()"> <small
                                id="priceWarning"
                                style="color: #dc3545; display: none; font-weight: bold; margin-top: 5px;">
                                <i class="fa-solid fa-triangle-exclamation"></i> Warning: Price is lower than Import
                                Cost!
                            </small>
                        </div>

                        <div class="form-group">
                            <label>Import Price (đ) [Admin Only] <span style="color:red">*</span></label>
                            <input type="number" class="form-control" step="0.01" min="0.01" name="importPrice"
                                id="importPrice" value="${book.importPrice}" required oninput="checkPriceGap()">
                        </div>

                        <div class="form-group">
                            <label>Stock Quantity <span style="color:red">*</span></label>
                            <input type="number" class="form-control" min="0" step="1" name="quantity"
                                value="${book.stockQuantity}" required>
                        </div>
                    </div>
                    <script>
                function checkPriceGap() {
                    // 1. Get current values (default to 0 if empty)
                    let selling = parseFloat(document.getElementById("sellingPrice").value) || 0;
                    let importCost = parseFloat(document.getElementById("importPrice").value) || 0;
                    let warningBox = document.getElementById("priceWarning");

                    // 2. Compare
                    if (selling < importCost) {
                        warningBox.style.display = "block"; // Show warning
                    } else {
                        warningBox.style.display = "none";  // Hide warning
                    }
                }

                // Run once on page load (in case editing an existing book that is already a Loss)
                document.addEventListener("DOMContentLoaded", checkPriceGap);
            </script>



                    <div class="form-row">
                        <div class="form-group">
                            <label>Publisher (Optional)</label>
                            <input type="text" class="form-control" name="publisher" value="${book.publisher}"
                                maxlength="100">
                        </div>
                        <div class="form-group">
                            <label>ISBN (Optional)</label>
                            <input type="text" class="form-control" name="isbn" value="${book.isbn}" maxlength="20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Book Cover Image</label>
                        <c:if test="${not empty book.imageUrl}">
                            <div style="margin-bottom: 10px;">
                                <img src="${pageContext.request.contextPath}/assets/image/books/${book.imageUrl}"
                                    height="100" class="preview-img">
                            </div>
                        </c:if>
                        <input type="file" class="form-control" name="imageFile" accept="image/*" ${book==null
                            ? 'required' : '' }>
                        <small style="color: #666;">Allowed: JPG, PNG, WEBP</small>
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <textarea class="form-control" name="description" rows="5" maxlength="5000" required
                            placeholder="Enter book details...">${book.description}</textarea>
                        <small class="text-muted">Max 5000 characters.</small>
                    </div>

                    <div class="form-group">
                        <label style="cursor: pointer; display: inline-flex; align-items: center; font-weight: normal;">
                            <input type="checkbox" name="active" value="true" ${book==null || book.active ? 'checked'
                                : '' } style="width: auto; margin-right: 10px; transform: scale(1.2);">
                            <strong>Is Active</strong> (Visible to customers)
                        </label>
                    </div>

                    <div style="text-align: right; margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/admin/product/list" class="btn-cancel">Cancel</a>
                        <button type="submit" class="btn-submit"><i class="fa-solid fa-save"></i> Save Book</button>
                    </div>
                </form>
            </div>
            <script>
                document.querySelector('textarea[name="description"]').addEventListener('input', function () {
                    // Find or create the counter element
                    let counter = document.getElementById('char-counter');
                    if (!counter) {
                        counter = document.createElement('small');
                        counter.id = 'char-counter';
                        counter.style.color = '#666';
                        counter.style.display = 'block';
                        counter.style.textAlign = 'right';
                        this.parentNode.appendChild(counter);
                    }

                    // Update the text
                    let currentLength = this.value.length;
                    let maxLength = this.getAttribute('maxlength');
                    counter.textContent = currentLength + " / " + maxLength + " characters";

                    // Turn red if close to limit
                    if (currentLength >= maxLength) {
                        counter.style.color = 'red';
                    } else {
                        counter.style.color = '#666';
                    }
                });
            </script>
            
        </body>

        </html>