<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <title>Product Manager</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage-products.css?v=8">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
                                <option value="all" ${searchCid=='all' || empty searchCid ? 'selected' : '' }>All
                                    Categories
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
                                        <th>
                                            <a
                                                href="list?sortBy=book_id&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${param.keyword}&cid=${param.cid}">
                                                ID <i
                                                    class="fa-solid fa-sort${sortBy == 'book_id' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                            </a>
                                        </th>

                                        <th>Image</th>

                                        <th>
                                            <a
                                                href="list?sortBy=title&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${param.keyword}&cid=${param.cid}">
                                                Book Details <i
                                                    class="fa-solid fa-sort${sortBy == 'title' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                            </a>
                                        </th>

                                        <th>
                                            <a
                                                href="list?sortBy=category_name&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${param.keyword}&cid=${param.cid}">
                                                Category <i
                                                    class="fa-solid fa-sort${sortBy == 'category_name' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                            </a>
                                        </th>

                                        <th>
                                            <a
                                                href="list?sortBy=price&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${param.keyword}&cid=${param.cid}">
                                                Price <i
                                                    class="fa-solid fa-sort${sortBy == 'price' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                            </a>
                                        </th>

                                        <th>
                                            <a
                                                href="list?sortBy=stock_quantity&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${param.keyword}&cid=${param.cid}">
                                                Stock <i
                                                    class="fa-solid fa-sort${sortBy == 'stock_quantity' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                            </a>
                                        </th>

                                        <th>
                                            <a
                                                href="list?sortBy=is_active&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${param.keyword}&cid=${param.cid}">
                                                Status <i
                                                    class="fa-solid fa-sort${sortBy == 'is_active' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                            </a>
                                        </th>

                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listBooks}" var="b">
                                        <tr class="${!b.active ? 'row-hidden' : ''}">
                                            <td>${b.id}</td>
                                            <td>
                                                <span style="color:red; font-size: 10px;">Path: [${b.coverImage}]</span>
                                                <c:choose>

                                                    <c:when test="${not empty b.coverImage}">
                                                        <img src="${pageContext.request.contextPath}/${b.coverImage}"
                                                            alt="Cover"
                                                            style="width: 50px; height: 70px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div
                                                            style="width: 50px; height: 70px; background-color: #e9ecef; border-radius: 4px; display: flex; align-items: center; justify-content: center; border: 1px solid #ddd;">
                                                            <i class="fa-solid fa-image" style="color: #adb5bd;"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div style="font-weight: bold; font-size: 1.1em; color: #333;">
                                                    ${b.title}
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
                            <div class="pagination"
                                style="display: flex; flex-wrap: wrap; justify-content: center; align-items: center; margin-top: 20px; gap: 5px;">

                                <c:if test="${tag > 1}">
                                    <a href="list?index=${tag-1}&keyword=${param.keyword}&cid=${param.cid}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                        class="page-btn">&laquo;</a>
                                </c:if>

                                <c:forEach begin="1" end="${endPage}" var="i">
                                    <c:choose>
                                        <%-- 1. Always show Page 1, Last Page, and the +/- 2 neighbors of the current
                                            page --%>
                                            <c:when test="${i == 1 || i == endPage || (i >= tag - 2 && i <= tag + 2)}">
                                                <a href="list?index=${i}&keyword=${param.keyword}&cid=${param.cid}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                                    class="page-btn ${tag == i ? 'active' : ''}">
                                                    ${i}
                                                </a>
                                            </c:when>

                                            <%-- 2. Show the Ellipsis (...) exactly one step outside our viewing window
                                                --%>
                                                <c:when test="${i == tag - 3 || i == tag + 3}">
                                                    <span
                                                        style="padding: 5px 10px; color: #6c757d; font-weight: bold;">...</span>
                                                </c:when>
                                    </c:choose>
                                </c:forEach>

                                <c:if test="${tag < endPage}">
                                    <a href="list?index=${tag+1}&keyword=${param.keyword}&cid=${param.cid}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                        class="page-btn">&raquo;</a>
                                </c:if>

                            </div>

                        </div>
                    </div>



                </body>

                </html>
