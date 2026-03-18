<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Manage Categories</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <style>
        /* 1. Global Reset to clean font */
        body,
        table,
        th,
        td,
        h2,
        a,
        button {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
        }

        body {
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .container {
            padding: 30px;
        }

        h2 {
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
        }

        /* 2. Enhanced Card Styling */
        .category-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 30px;
            margin-top: 10px;
        }

        .table-custom {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }

        /* 3. Header Styling */
        .table-custom th {
            text-transform: uppercase;
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 0.5px;
            color: #7f8c8d;
            padding: 15px;
            border-bottom: 2px solid #f1f1f1;
        }

        /* 4. Parent vs Child Row distinction */
        .parent-row {
            background-color: #f9fbfc !important;
        }

        .parent-row td {
            font-weight: 600;
            /* Bold for parents */
            color: #34495e;
            border-top: 1px solid #ebedef;
            border-bottom: 1px solid #ebedef;
        }

        .child-row td {
            color: #636e72;
            font-weight: 400;
            /* Normal weight for children */
        }

        /* 5. Icons and Spacing */
        .indent-icon {
            color: #bdc3c7;
            margin-right: 15px;
            font-size: 0.85em;
        }

        .btn-submit {
            background-color: #28a745;
            color: white;
            padding: 10px 24px;
            border-radius: 6px;
            font-weight: 600;
            transition: 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-submit:hover {
            background-color: #218838;
            transform: translateY(-1px);
        }
    </style>

    <body>
        <div class="category-card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                <h2 style="margin: 0;">Category Management</h2>
                <a href="${pageContext.request.contextPath}/admin/category/add" class="btn-submit"
                    style="width: auto; padding: 10px 20px; text-decoration: none; display: flex; align-items: center;">
                    <i class="fa-solid fa-plus" style="margin-right: 8px;"></i> Add New Category
                </a>
            </div>

            <table class="table-custom">
                <thead>
                    <tr>
                        <%-- NEW TH --%>
                            <th style="width: 80px; text-align: center;">Icon</th>
                            <th>Category Hierarchy</th>
                            <th>Description</th>
                            <th style="text-align: center;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${listCategories}" var="parent">
                        <c:if test="${empty parent.parentId}">
                            <%-- Parent Row --%>
                                <tr class="parent-row">
                                    <td style="text-align: center; padding: 10px;">
                                        <c:if test="${not empty parent.imageUrl}">
                                            <img src="${pageContext.request.contextPath}/${parent.imageUrl}"
                                                style="width: 45px; height: 45px; border-radius: 6px; object-fit: cover; border: 1px solid #ddd;"
                                                onerror="this.style.display='none'">
                                        </c:if>
                                    </td>
                                    <td style="padding: 15px;">
                                        <i class="fa-solid fa-folder-open"
                                            style="margin-right: 8px; color: #4e73df;"></i>
                                        ${parent.name}
                                    </td>
                                    <td>${parent.description}</td>
                                    <td style="text-align: center;">
                                        <a href="category/edit?id=${parent.id}" class="btn-action btn-edit">
                                            <i class="fa-solid fa-pen"></i>
                                        </a>
                                        <form action="category/delete" method="POST" style="display:inline;">
                                            <input type="hidden" name="id" value="${parent.id}">
                                            <button type="submit" class="btn-action btn-delete"
                                                onclick="return confirm('Deleting a parent will affect all sub-categories. Continue?')">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>

                                <%-- Child Rows --%>
                                    <c:forEach items="${listCategories}" var="child">
                                        <c:if test="${child.parentId == parent.id}">
                                            <tr class="child-row">
                                                <td></td>
                                                <td style="padding: 15px 15px 15px 45px;">
                                                    <i class="fa-solid fa-turn-up fa-rotate-90 indent-icon"></i>
                                                    ${child.name}
                                                </td>
                                                <td>${child.description}</td>
                                                <td style="text-align: center;">
                                                    <a href="category/edit?id=${child.id}" class="btn-action btn-edit">
                                                        <i class="fa-solid fa-pen"></i>
                                                    </a>
                                                    <form action="category/delete" method="POST"
                                                        style="display:inline;">
                                                        <input type="hidden" name="id" value="${child.id}">
                                                        <button type="submit" class="btn-action btn-delete"
                                                            onclick="return confirm('Are you sure you want to delete this sub-category?')">
                                                            <i class="fa-solid fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <%@ include file="admin-notifications.jsp" %>
    </body>

    </html>