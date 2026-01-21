<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý kho hàng - Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body { background-color: #f8f9fa; }
        /* Style cho link ở tiêu đề bảng */
        .table th a {
            color: white;
            text-decoration: none;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
        }
        .table th a:hover { color: #d1d1d1; }
    </style>
</head>
<body>

<div class="container mt-5">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fa-solid fa-boxes-stacked text-primary"></i> Kho Hàng</h2>
        <a href="${pageContext.request.contextPath}/warehouse/dashboard" class="btn btn-secondary">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>

    <div class="card p-4 mb-4 shadow-sm">
        <form action="inventory" method="get" class="row g-3">
            <div class="col-md-4">
                <input type="text" name="search" class="form-control" 
                       placeholder="Tìm tên sách..." value="${param.search}">
            </div>

            <div class="col-md-3">
                <select name="cid" class="form-select" onchange="this.form.submit()">
                    <option value="0">-- Thể loại --</option>
                    <option value="1" ${param.cid==1?'selected':''}>Kinh tế</option>
                    <option value="2" ${param.cid==2?'selected':''}>Văn học</option>
                    <option value="3" ${param.cid==3?'selected':''}>Thiếu nhi</option>
                    <option value="4" ${param.cid==4?'selected':''}>Ngoại ngữ</option>
                    <option value="5" ${param.cid==5?'selected':''}>Kỹ năng sống</option>
                </select>
            </div>

            <div class="col-md-3">
                <select name="author" class="form-select" onchange="this.form.submit()">
                    <option value="">-- Tác giả --</option>
                    <c:forEach items="${listAuthors}" var="a">
                        <option value="${a}" ${param.author == a ? 'selected' : ''}>${a}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-2">
                <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
            </div>
            
            <input type="hidden" name="col" value="${sortCol}">
            <input type="hidden" name="order" value="${sortOrder}">
        </form>
    </div>

    <div class="table-responsive shadow-sm">
        <table class="table table-bordered table-striped table-hover align-middle">
            <thead class="table-dark">
                <tr>
                    <th style="width: 50px;">STT</th>
                    
                    <th>
                        <c:set var="nextOrder" value="${(sortCol == 'title' && sortOrder == 'ASC') ? 'DESC' : 'ASC'}"/>
                        <a href="inventory?col=title&order=${nextOrder}&search=${param.search}&cid=${param.cid}&author=${param.author}">
                            Tên sách
                            <span>
                                <c:if test="${sortCol == 'title'}"><i class="fa-solid fa-arrow-${sortOrder == 'ASC' ? 'up' : 'down'}"></i></c:if>
                                <c:if test="${sortCol != 'title'}"><i class="fa-solid fa-sort text-secondary"></i></c:if>
                            </span>
                        </a>
                    </th>

                    <th style="min-width: 150px;">
                        <c:set var="nextOrderAuthor" value="${(sortCol == 'author' && sortOrder == 'ASC') ? 'DESC' : 'ASC'}"/>
                        <a href="inventory?col=author&order=${nextOrderAuthor}&search=${param.search}&cid=${param.cid}&author=${param.author}">
                            Tác giả
                            <span>
                                <c:if test="${sortCol == 'author'}"><i class="fa-solid fa-arrow-${sortOrder == 'ASC' ? 'up' : 'down'}"></i></c:if>
                                <c:if test="${sortCol != 'author'}"><i class="fa-solid fa-sort text-secondary"></i></c:if>
                            </span>
                        </a>
                    </th>

                    <th style="min-width: 120px;">
                        <c:set var="nextOrderCate" value="${(sortCol == 'category' && sortOrder == 'ASC') ? 'DESC' : 'ASC'}"/>
                        <a href="inventory?col=category&order=${nextOrderCate}&search=${param.search}&cid=${param.cid}&author=${param.author}">
                            Thể loại
                            <span>
                                <c:if test="${sortCol == 'category'}"><i class="fa-solid fa-arrow-${sortOrder == 'ASC' ? 'up' : 'down'}"></i></c:if>
                                <c:if test="${sortCol != 'category'}"><i class="fa-solid fa-sort text-secondary"></i></c:if>
                            </span>
                        </a>
                    </th>

                    <th style="min-width: 120px;">
                        <c:set var="nextOrderPub" value="${(sortCol == 'publisher' && sortOrder == 'ASC') ? 'DESC' : 'ASC'}"/>
                        <a href="inventory?col=publisher&order=${nextOrderPub}&search=${param.search}&cid=${param.cid}&author=${param.author}">
                            NXB
                            <span>
                                <c:if test="${sortCol == 'publisher'}"><i class="fa-solid fa-arrow-${sortOrder == 'ASC' ? 'up' : 'down'}"></i></c:if>
                                <c:if test="${sortCol != 'publisher'}"><i class="fa-solid fa-sort text-secondary"></i></c:if>
                            </span>
                        </a>
                    </th>

                    <th>
                        <c:set var="nextOrderPrice" value="${(sortCol == 'price' && sortOrder == 'ASC') ? 'DESC' : 'ASC'}"/>
                        <a href="inventory?col=price&order=${nextOrderPrice}&search=${param.search}&cid=${param.cid}&author=${param.author}">
                            Giá ($)
                            <span>
                                <c:if test="${sortCol == 'price'}"><i class="fa-solid fa-arrow-${sortOrder == 'ASC' ? 'up' : 'down'}"></i></c:if>
                                <c:if test="${sortCol != 'price'}"><i class="fa-solid fa-sort text-secondary"></i></c:if>
                            </span>
                        </a>
                    </th>

                    <th>
                        <c:set var="nextOrderStock" value="${(sortCol == 'stock' && sortOrder == 'ASC') ? 'DESC' : 'ASC'}"/>
                        <a href="inventory?col=stock&order=${nextOrderStock}&search=${param.search}&cid=${param.cid}&author=${param.author}">
                            Kho
                            <span>
                                <c:if test="${sortCol == 'stock'}"><i class="fa-solid fa-arrow-${sortOrder == 'ASC' ? 'up' : 'down'}"></i></c:if>
                                <c:if test="${sortCol != 'stock'}"><i class="fa-solid fa-sort text-secondary"></i></c:if>
                            </span>
                        </a>
                    </th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty listB}">
                    <tr>
                        <td colspan="7" class="text-center text-danger py-4">
                            Không tìm thấy sách nào phù hợp!
                        </td>
                    </tr>
                </c:if>

                <c:forEach items="${listB}" var="b">
                    <tr>
                        <td>${b.id}</td>
                        <td class="fw-bold text-primary">${b.title}</td>
                        <td>${b.author}</td>
                        
                        <td>
                            <c:choose>
                                <c:when test="${b.categoryId == 1}">Kinh tế</c:when>
                                <c:when test="${b.categoryId == 2}">Văn học</c:when>
                                <c:when test="${b.categoryId == 3}">Thiếu nhi</c:when>
                                <c:when test="${b.categoryId == 4}">Ngoại ngữ</c:when>
                                <c:when test="${b.categoryId == 5}">Kỹ năng sống</c:when>
                                <c:otherwise><span class="text-muted">Khác</span></c:otherwise>
                            </c:choose>
                        </td>

                        <td>${b.publisher}</td>

                        <td class="fw-bold text-success">${b.price}</td>
                        <td>
                            <c:choose>
                                <c:when test="${b.stockQuantity < 5}">
                                    <span class="badge bg-danger">${b.stockQuantity}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-success">${b.stockQuantity}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>