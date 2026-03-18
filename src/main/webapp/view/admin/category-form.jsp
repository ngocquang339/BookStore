<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>${category != null ? 'Edit Category' : 'Add New Category'} | Admin</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                body {
                    font-family: 'Segoe UI', sans-serif !important;
                    background-color: #f4f6f9;
                }

                .form-container {
                    max-width: 600px;
                    margin: 50px auto;
                    background: white;
                    padding: 40px;
                    border-radius: 8px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                }

                h2 {
                    text-align: center;
                    margin-bottom: 30px;
                    color: #333;
                    font-weight: 700;
                }

                .form-group {
                    margin-bottom: 25px;
                }

                .form-label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 600;
                    color: #555;
                }

                .form-control {
                    width: 100%;
                    padding: 12px;
                    border: 1px solid #ddd;
                    border-radius: 6px;
                    font-size: 15px;
                }

                .btn-submit {
                    background-color: #28a745;
                    color: white;
                    border: none;
                    padding: 12px 20px;
                    border-radius: 6px;
                    cursor: pointer;
                    width: 100%;
                    font-size: 16px;
                    font-weight: 600;
                }

                .back-link {
                    display: block;
                    margin-top: 20px;
                    text-align: center;
                    color: #6c757d;
                    text-decoration: none;
                }
            </style>
        </head>

        <body>
            <div class="form-container">
                <%-- Dynamic Header --%>
                    <h2>${category != null ? 'Edit Existing Category' : 'Add New Category'}</h2>

                    <%-- Use context path to ensure URL is always correct --%>
                        <%-- ADDED enctype AND an ID for the JS --%>
                            <form id="categoryForm"
                                action="${pageContext.request.contextPath}/admin/category/${category != null ? 'edit' : 'add'}"
                                method="post" enctype="multipart/form-data">

                                <input type="hidden" name="action" id="formAction"
                                    value="${category != null ? 'edit' : 'add'}">

                                <c:if test="${category != null}">
                                    <input type="hidden" name="id" value="${category.id}">
                                    <%-- ADDED hidden image field to preserve old images --%>
                                        <input type="hidden" name="currentImage" value="${category.imageUrl}">
                                </c:if>

                                <div class="form-group">
                                    <label class="form-label">Category Name <span style="color: red;">*</span></label>
                                    <input type="text" name="categoryName" class="form-control" value="${category.name}"
                                        required maxlength="100" placeholder="Maximum 100 characters">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Parent Category</label>
                                    <select name="parentId" id="parentDropdown" class="form-control">
                                        <option value="">-- None (This is a Parent) --</option>
                                        <c:forEach items="${listCategories}" var="cat">
                                            <c:if test="${empty cat.parentId && cat.id != category.id}">
                                                <option value="${cat.id}" ${category.parentId==cat.id ? 'selected' : ''
                                                    }>${cat.name}</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>

                                <%-- ✨ NEW: Image Upload Section ✨ --%>
                                    <div class="form-group">
                                        <label class="form-label">Category Icon (Required for Parents)</label>
                                        <c:if test="${not empty category.imageUrl}">
                                            <div style="margin-bottom: 10px;">
                                                <img src="${pageContext.request.contextPath}/${category.imageUrl}"
                                                    height="60" style="border-radius: 4px; border: 1px solid #ddd;">
                                            </div>
                                        </c:if>
                                        <input type="file" id="imageFile" name="imageFile" class="form-control"
                                            accept="image/*">
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Description</label>
                                        <textarea name="description" class="form-control" rows="4" maxlength="2000"
                                            placeholder="Optional category description...">${category.description}</textarea>
                                    </div>

                                    <button type="button" class="btn-submit" onclick="validateAndSubmit()">
                                        <i class="fa-solid fa-save"></i> ${category != null ? 'Save Changes' : 'Create
                                        Category'}
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/categories"
                                        class="back-link">Cancel and Return</a>
                            </form>

                            <%-- The clever JS validation --%>
                                <script>
                                    function validateAndSubmit() {
                                        let action = document.getElementById('formAction').value;
                                        let parentId = document.getElementById('parentDropdown').value;
                                        let fileInput = document.getElementById('imageFile');
                                        let form = document.getElementById('categoryForm');

                                        // Rule: If Adding a NEW category, AND it is a Parent (parentId is empty), require a file!
                                        if (action === 'add' && parentId === "") {
                                            if (fileInput.files.length === 0) {
                                                alert("Please upload an image for new Parent Categories!");
                                                return; // Stop the function, don't submit
                                            }
                                        }

                                        // If it passes the check, submit!
                                        form.submit();
                                    }

                                    function attachCharCounter(selector) {
                                        const elements = document.querySelectorAll(selector);

                                        elements.forEach(element => {
                                            element.addEventListener('input', function () {
                                                // Find or create the counter element below the input
                                                let counter = this.parentNode.querySelector('.char-counter');
                                                if (!counter) {
                                                    counter = document.createElement('small');
                                                    counter.className = 'char-counter';
                                                    counter.style.color = '#6c757d';
                                                    counter.style.display = 'block';
                                                    counter.style.textAlign = 'right';
                                                    counter.style.marginTop = '5px';
                                                    counter.style.fontWeight = '500';
                                                    this.parentNode.appendChild(counter);
                                                }

                                                // Calculate lengths
                                                let currentLength = this.value.length;
                                                let maxLength = this.getAttribute('maxlength');

                                                // Only show counter if maxlength is defined
                                                if (maxLength) {
                                                    counter.textContent = currentLength + " / " + maxLength;

                                                    // Color logic: Red if maxed out, Orange if at 90%, Gray otherwise
                                                    if (currentLength >= maxLength) {
                                                        counter.style.color = '#dc3545'; // Danger Red
                                                    } else if (currentLength >= maxLength * 0.9) {
                                                        counter.style.color = '#ffc107'; // Warning Yellow
                                                    } else {
                                                        counter.style.color = '#6c757d'; // Standard Gray
                                                    }
                                                }
                                            });

                                            // Trigger the input event immediately on page load 
                                            // This is crucial for "Edit" mode so it counts the existing text!
                                            element.dispatchEvent(new Event('input'));
                                        });
                                    }

                                    // 2. Run the counter function when the page loads
                                    document.addEventListener("DOMContentLoaded", function () {
                                        // Target specifically the Category Name and Description fields
                                        attachCharCounter('input[name="categoryName"], textarea[name="description"]');
                                    });
                                </script>
            </div>
            <%@ include file="admin-notifications.jsp" %>
        </body>

        </html>