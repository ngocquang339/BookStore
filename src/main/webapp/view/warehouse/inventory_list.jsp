<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Inventory List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <a href="dashboard" class="btn btn-secondary mb-3">&larr; Quay lại Dashboard</a>
    <h3 class="text-primary">DANH SÁCH TỒN KHO</h3>

    <form action="inventory" method="get" class="row g-3 mb-4">
        <div class="col-md-6">
            <input type="text" name="search" class="form-control" placeholder="Tìm tên sách..." value="${param.search}">
        </div>
        <div class="col-md-4">
            <select name="cid" class="form-select">
                <option value="0">Tất cả thể loại</option>
                <option value="1" ${param.cid==1?'selected':''}>Kinh tế</option>
                <option value="2" ${param.cid==2?'selected':''}>Văn học</option>
                <option value="3" ${param.cid==3?'selected':''}>Thiếu nhi</option>
                <option value="4" ${param.cid==4?'selected':''}>Công nghệ</option>
            </select>
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
        </div>
    </form>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên sách</th>
                <th>Tác giả</th>
                <th>Số lượng</th>
                <th>Trạng thái</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${listB}" var="b">
                <tr>
                    <td>${b.id}</td>
                    <td><img src="${b.imageUrl}" width="50"></td>
                    <td>${b.title}</td>
                    <td>${b.author}</td>
                    <td>${b.stockQuantity}</td>
                    <td>
                        <c:if test="${b.stockQuantity < 5}"><span class="badge bg-danger">Sắp hết</span></c:if>
                        <c:if test="${b.stockQuantity >= 5}"><span class="badge bg-success">Còn hàng</span></c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>