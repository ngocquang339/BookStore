<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>Product Manager</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage-products.css?v=2">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <style>

                </style>
            </head>

            <body>

                <div class="page-container">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">
                        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
                    </a>

                    <div class="header-actions">
                        <h1><i class="fa-solid fa-box-open"></i> Product Management</h1>
                        <a href="${pageContext.request.contextPath}/admin/category/add" class="btn-add-new"
                            style="background-color: #17a2b8; margin-right: 10px;">
                            <i class="fa-solid fa-tags"></i> Add Category
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/product/add" class="btn-add-new">
                            <i class="fa-solid fa-plus"></i> Add New Book
                        </a>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/product/list" method="get"
                        class="filter-bar">
                        <input type="text" name="keyword" class="search-input" placeholder="Search by book title..."
                            value="${searchKeyword}">

                        <select name="cid" class="filter-select">
                            <option value="all" ${searchCid=='all' || empty searchCid ? 'selected' : '' }>All Categories
                            </option>
                            <c:forEach items="${listCategories}" var="c">
                                <option value="${c.id}" ${searchCid ne 'all' && searchCid==c.id ? 'selected' : '' }>
                                    ${c.name}
                                </option>
                            </c:forEach>
                        </select>

                        <button type="submit" class="btn-search">
                            <i class="fa-solid fa-magnifying-glass"></i> Search
                        </button>

                        <c:if test="${not empty searchKeyword or (not empty searchCid and searchCid != 'all')}">
                            <a href="${pageContext.request.contextPath}/admin/product/list"
                                style="color:#666; text-decoration:none; font-size:14px;">Clear</a>
                        </c:if>
                    </form>

                    <div class="table-responsive">
                        <table class="admin-table" id="productTable">
                            <thead>
                                <tr>
                                    <th onclick="sortTable(0)">ID</th>
                                    <th onclick="sortTable(1)">Image</th>
                                    <th onclick="sortTable(2)">Book Details</th>

                                    <th onclick="sortTable(3)">Category</th>

                                    <th onclick="sortTable(4)">Price</th>
                                    <th onclick="sortTable(5)">Stock</th>
                                    <th onclick="sortTable(6)">Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${listBooks}" var="b">
                                    <tr class="${!b.active ? 'row-hidden' : ''}">
                                        <td>${b.id}</td>
                                        <td>
                                            <div
                                                style="width: 50px; height: 75px; overflow: hidden; border-radius: 4px; border: 1px solid #eee;">
                                                <img class="table-img"
                                                    src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}"
                                                    alt="${b.title}"
                                                    style="width: 100%; height: 100%; object-fit: cover;"
                                                    onerror="this.onerror=null; this.src='https://placehold.co/50x75?text=No+Image';">
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-weight: bold; font-size: 1.1em; color: #333;">${b.title}
                                            </div>
                                            <div style="color: #666; font-size: 0.9em;"><i
                                                    class="fa-solid fa-user-pen"></i> ${b.author}</div>
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary"
                                                style="font-weight: 500; font-size: 0.9rem;">
                                                ${b.categoryName}
                                            </span>
                                        </td>
                                        <td>
                                            <strong style="color: #C92127;">
                                                <fmt:formatNumber value="${b.price}" type="currency"
                                                    currencySymbol="đ" />
                                            </strong>
                                        </td>
                                        <td>
                                            <span class="${b.stockQuantity <= 5 ? 'stock-warning' : ''}">
                                                ${b.stockQuantity}
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${b.active}">
                                                <span class="status-active"><i class="fa-solid fa-check"></i>
                                                    Active</span>
                                            </c:if>
                                            <c:if test="${!b.active}">
                                                <span class="status-hidden"><i class="fa-solid fa-eye-slash"></i>
                                                    Hidden</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <a href="edit?id=${b.id}" class="btn-sm btn-edit">
                                                <i class="fa-solid fa-pen"></i> Edit
                                            </a>
                                            <a href="delete?id=${b.id}" class="btn-sm btn-delete"
                                                onclick="return confirm('Are you sure you want to soft-delete this book?');">
                                                <i class="fa-solid fa-trash"></i> Delete
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <script>
                    function sortTable(n, type) {
                        var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
                        table = document.getElementById("productTable");
                        switching = true;
                        dir = "asc"; // Set the sorting direction to ascending:

                        while (switching) {
                            switching = false;
                            rows = table.rows;

                            // Loop through all table rows (except the first, which contains table headers):
                            for (i = 1; i < (rows.length - 1); i++) {
                                shouldSwitch = false;

                                // Get the two elements you want to compare
                                x = rows[i].getElementsByTagName("TD")[n];
                                y = rows[i + 1].getElementsByTagName("TD")[n];

                                var xContent = x.innerText.toLowerCase();
                                var yContent = y.innerText.toLowerCase();

                                // CLEANUP DATA BASED ON TYPE
                                if (type === 'number') {
                                    xContent = parseFloat(xContent) || 0;
                                    yContent = parseFloat(yContent) || 0;
                                } else if (type === 'price') {
                                    // Remove "đ", dots, commas
                                    xContent = parseFloat(xContent.replace(/[^0-9.-]+/g, "")) || 0;
                                    yContent = parseFloat(yContent.replace(/[^0-9.-]+/g, "")) || 0;
                                }

                                // COMPARE
                                if (dir == "asc") {
                                    if (xContent > yContent) {
                                        shouldSwitch = true;
                                        break;
                                    }
                                } else if (dir == "desc") {
                                    if (xContent < yContent) {
                                        shouldSwitch = true;
                                        break;
                                    }
                                }
                            }

                            if (shouldSwitch) {
                                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                                switching = true;
                                switchcount++;
                            } else {
                                if (switchcount == 0 && dir == "asc") {
                                    dir = "desc";
                                    switching = true;
                                }
                            }
                        }
                    }
                </script>

            </body>

            </html>