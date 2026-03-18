<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Warehouse Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>

    <body class="bg-light">
        <div class="container mt-5">
            <h2 class="text-center mb-4"><i class="fas fa-warehouse text-secondary"></i> QUẢN LÝ KHO HÀNG</h2>

            <div class="row text-center g-4">

                <div class="col-md-4">
                    <div class="card p-4 shadow-sm h-100 border-primary">
                        <h4 class="text-primary"><i class="fas fa-boxes"></i> Inventory List</h4>
                        <p>Xem danh sách toàn bộ sách, tìm kiếm và lọc.</p>
                        <a href="inventory" class="btn btn-primary mt-auto">Truy cập</a>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card p-4 shadow-sm h-100 border-warning">
                        <h4 class="text-warning"><i class="fas fa-exclamation-triangle"></i> Low Stock Books</h4>
                        <p>Xem các sách sắp hết hàng cần nhập thêm.</p>
                        <a href="low-stock" class="btn btn-warning mt-auto text-dark">Truy cập</a>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card p-4 shadow-sm h-100 border-success">
                        <h4 class="text-success"><i class="fa-solid fa-truck-fast"></i> Supplier Mng.</h4>
                        <p>Quản lý thông tin nhà cung cấp, NXB (Thêm, Sửa, Xóa).</p>
                        <a href="supplier" class="btn btn-success mt-auto">Truy cập</a>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card p-4 shadow-sm h-100 border-info">
                        <h4 class="text-info"><i class="fa-solid fa-map-location-dot"></i> Location Setup</h4>
                        <p>Thiết lập sơ đồ kho: Khu vực, Kệ, Tầng.</p>
                        <a href="location" class="btn btn-info text-white mt-auto">Truy cập</a>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card p-4 shadow-sm h-100 border-danger">
                        <h4 class="text-danger"><i class="fas fa-clipboard-check"></i> View Sale Order and Picking List
                        </h4>
                        <p>Xem đơn hàng xuất kho, nhặt hàng (Picking) và giao vận chuyển.</p>
                        <a href="${pageContext.request.contextPath}/warehouse/orders"
                            class="btn btn-danger mt-auto">Truy cập</a>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card p-4 shadow-sm h-100 border-secondary">
                        <h4 class="text-secondary"><i class="fas fa-dolly"></i> Create Purchase Order</h4>
                        <p>Quản lý các yêu cầu nhập hàng từ nhà cung cấp vào kho.</p>
                        <a href="${pageContext.request.contextPath}/create-po" class="btn btn-secondary mt-auto">
                            Truy cập
                        </a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-4 shadow-sm h-100 border-dark">
                        <h4 class="text-dark">
                            <i class="fas fa-clipboard-list"></i> Purchase Orders
                        </h4>
                        <p>Xem danh sách đơn nhập hàng và thực hiện nhập kho.</p>
                        <a href="${pageContext.request.contextPath}/warehouse/view-po" class="btn btn-dark mt-auto">
                            Truy cập
                        </a>
                    </div>
                </div>

            </div>
            <div class="text-center mt-5 mb-5">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>