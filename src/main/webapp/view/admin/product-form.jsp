<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

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
                                <select name="categoryId" class="form-control" required>
                                    <option value="" disabled ${empty book ? 'selected' : '' }>-- Choose a Category --
                                    </option>

                                    <%-- Loop 1: Find all the Parent Categories --%>
                                        <c:forEach items="${listCategories}" var="parent">
                                            <c:if test="${empty parent.parentId}">

                                                <%-- PRE-CHECK: Scan the list to see if this parent has any children
                                                    --%>
                                                    <c:set var="hasChildren" value="false" />
                                                    <c:forEach items="${listCategories}" var="childCheck">
                                                        <c:if test="${childCheck.parentId == parent.id}">
                                                            <c:set var="hasChildren" value="true" />
                                                        </c:if>
                                                    </c:forEach>

                                                    <%-- Make the elegant, unclickable header --%>
                                                        <optgroup label="${parent.name}">

                                                            <c:choose>
                                                                <%-- SCENARIO A: It HAS children. Force the user to pick
                                                                    a child. --%>
                                                                    <c:when test="${hasChildren}">
                                                                        <c:forEach items="${listCategories}"
                                                                            var="child">
                                                                            <c:if test="${child.parentId == parent.id}">
                                                                                <option value="${child.id}"
                                                                                    ${book.categoryId==child.id
                                                                                    ? 'selected' : '' }>
                                                                                    ${child.name}
                                                                                </option>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </c:when>

                                                                    <%-- SCENARIO B: No children exist yet. Allow
                                                                        selecting the parent directly. --%>
                                                                        <c:otherwise>
                                                                            <option value="${parent.id}"
                                                                                ${book.categoryId==parent.id
                                                                                ? 'selected' : '' }>
                                                                                ${parent.name}
                                                                            </option>
                                                                        </c:otherwise>
                                                            </c:choose>

                                                        </optgroup>

                                            </c:if>
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
                                <c:choose>
                                    <%-- EDIT MODE: Show latest PO price as read-only --%>
                                        <c:when test="${not empty book}">
                                            <label>Latest Import Price (đ) <span
                                                    style="font-weight:normal; color:#666;">[From PO]</span></label>
                                            <input type="number" class="form-control" name="importPrice"
                                                id="importPrice" value="${book.importPrice}" readonly
                                                style="background-color: #e9ecef; cursor: not-allowed;"
                                                title="Import prices are managed through Purchase Orders.">
                                        </c:when>

                                        <%-- CREATE MODE: Hide the import price field entirely since it doesn't exist
                                            yet --%>
                                            <c:otherwise>
                                                <input type="hidden" name="importPrice" id="importPrice" value="0">
                                            </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="form-group">
                                <c:choose>
                                    <%-- EDIT MODE: The book already exists, so lock the stock field --%>
                                        <c:when test="${not empty book}">
                                            <label>Stock Quantity (Managed via PO)</label>
                                            <input type="number" name="stockQuantity" value="${book.stockQuantity}"
                                                class="form-control" readonly
                                                style="background-color: #e9ecef; cursor: not-allowed;"
                                                title="Stock quantity can only be updated through Warehouse Purchase Orders.">
                                        </c:when>

                                        <%-- CREATE MODE: It's a brand new book, allow initial stock input --%>
                                            <c:otherwise>
                                                <label>Initial Stock Quantity <span class="text-danger">*</span></label>
                                                <input type="number" name="stockQuantity" value="0" class="form-control"
                                                    required placeholder="Enter starting stock">
                                            </c:otherwise>
                                </c:choose>
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



                        <%-- ROW 1: Publisher, Year, Pages --%>
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Publisher (Optional)</label>
                                    <input type="text" class="form-control" name="publisher" value="${book.publisher}"
                                        maxlength="100">
                                </div>
                                <div class="form-group">
                                    <label>Year of Publish (Optional)</label>
                                    <input type="number" class="form-control" name="yearOfPublish"
                                        value="${book.yearOfPublish}" min="1000" max="2099" placeholder="e.g., 2023">
                                </div>
                                <div class="form-group">
                                    <label>Number of Pages (Optional)</label>
                                    <input type="number" class="form-control" name="numberPage"
                                        value="${book.numberPage}" min="1" placeholder="e.g., 350">
                                </div>
                            </div>

                            <%-- ROW 2: ISBN and Supplier --%>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>ISBN (Optional)</label>
                                        <input type="text" class="form-control" name="isbn" value="${book.isbn}"
                                            maxlength="20">
                                    </div>
                                    <div class="form-group">
                                        <label>Supplier (Optional)</label>
                                        <input type="text" class="form-control" name="supplier" value="${book.supplier}"
                                            maxlength="255" placeholder="Name of the book supplier/distributor">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Book Cover Image</label>

                                    <%-- 1. Debug text (optional, but helpful if it breaks again) --%>
                                        <div style="font-size: 10px; color: #888; margin-bottom: 5px;">
                                            DB Path: [${book.imageUrl}]
                                        </div>

                                        <c:if test="${not empty book.imageUrl}">
                                            <div style="margin-bottom: 10px;">
                                                <%-- 2. FIX: Only use the context path, let the DB provide the folders
                                                    --%>
                                                    <img src="${pageContext.request.contextPath}/${book.imageUrl}"
                                                        height="150" class="preview-img"
                                                        style="border-radius: 4px; box-shadow: 0 2px 5px rgba(0,0,0,0.2);"
                                                        onerror="this.onerror=null; this.src='https://placehold.co/100x150/e9ecef/666666?text=Broken+Link';">
                                            </div>
                                        </c:if>

                                        <input type="file" class="form-control" name="imageFile" accept="image/*"
                                            ${book==null ? 'required' : '' }>
                                        <small style="color: #666;">Allowed: JPG, PNG, WEBP</small>
                                </div>

                                <div class="form-group">
                                    <label>Detail Images (Gallery)</label>

                                    <div style="font-size: 11px; color: blue; margin-bottom: 5px;">
                                        DEBUG: The server found ${fn:length(book.detailImages)} detail images.
                                    </div>
                                    <%-- Show existing detail images --%>
                                        <c:if test="${not empty book.detailImages}">
                                            <div
                                                style="display: flex; gap: 10px; margin-bottom: 10px; flex-wrap: wrap;">
                                                <c:forEach items="${book.detailImages}" var="detailImg">
                                                    <div
                                                        style="display: inline-block; text-align: center; margin-bottom: 10px;">
                                                        <%-- The Image --%>
                                                            <img src="${pageContext.request.contextPath}/${detailImg.imageUrl}"
                                                                height="100"
                                                                style="border-radius: 4px; border: 1px solid #ddd; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"
                                                                onerror="this.onerror=null; this.src='https://placehold.co/60x80/e9ecef/666666?text=Error';">
                                                            <br>
                                                            <%-- The Delete Checkbox --%>
                                                                <label
                                                                    style="color: #dc3545; font-size: 13px; cursor: pointer; display: flex; align-items: center; justify-content: center; margin-top: 5px; font-weight: bold;">
                                                                    <input type="checkbox" name="deleteImageIds"
                                                                        value="${detailImg.id}"
                                                                        style="margin-right: 5px; transform: scale(1.2);">
                                                                    Delete
                                                                </label>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>

                                        <%-- The 'multiple' attribute allows selecting several files at once --%>
                                            <input type="file" class="form-control" name="detailImages" accept="image/*"
                                                multiple>
                                            <small style="color: #666;">You can select multiple images by holding CTRL
                                                or
                                                SHIFT.</small>
                                </div>

                                <div class="form-group">
                                    <label>Description</label>
                                    <textarea class="form-control" name="description" rows="5" maxlength="5000" required
                                        placeholder="Enter book details...">${book.description}</textarea>
                                    <small class="text-muted">Max 5000 characters.</small>
                                </div>

                                <div class="form-group">
                                    <label
                                        style="cursor: pointer; display: inline-flex; align-items: center; font-weight: normal;">
                                        <input type="checkbox" name="active" value="true" ${book==null || book.active
                                            ? 'checked' : '' }
                                            style="width: auto; margin-right: 10px; transform: scale(1.2);">
                                        <strong>Is Active</strong> (Visible to customers)
                                    </label>
                                </div>

                                <div style="text-align: right; margin-top: 20px;">
                                    <a href="${pageContext.request.contextPath}/admin/product/list"
                                        class="btn-cancel">Cancel</a>
                                    <button type="submit" class="btn-submit"><i class="fa-solid fa-save"></i> Save
                                        Book</button>
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
                <%@ include file="admin-notifications.jsp" %>
            </body>

            </html>