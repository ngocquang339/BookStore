<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Warehouse Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-light">
        <div class="container mt-5">
            <h2 class="text-center mb-4">QUẢN LÝ KHO HÀNG</h2>
            <div class="row text-center">

                <div class="col-md-4">
                    <div class="card p-4 shadow-sm h-100">
                        <h4>Inventory List</h4>
                        <p>Xem danh sách toàn bộ sách, tìm kiếm và lọc.</p>
                        <a href="inventory" class="btn btn-primary mt-auto">Truy cập</a>
                    </div>
                </div>



                <div class="col-md-4">
                    <div class="card p-4 shadow-sm h-100">
                        <h4>Low Stock Books</h4>
                        <p>Xem các sách sắp hết hàng cần nhập thêm.</p>
                        <a href="low-stock" class="btn btn-warning mt-auto">Truy cập</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-4 shadow-sm h-100 border-success">
                        <h4 class="text-success"><i class="fa-solid fa-truck-fast"></i> Supplier Management</h4>
                        <p>Quản lý thông tin nhà cung cấp, NXB (Thêm, Sửa, Xóa).</p>
                        <a href="supplier" class="btn btn-success mt-auto">Truy cập</a>
                    </div>
                </div>
            </div>
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger">Đăng xuất</a>
            </div>
        </div>
    </body>

    </html>