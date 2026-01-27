<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Tồn kho</title>

                <!-- Bootstrap -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/inventory.css">
            </head>

            <body>

                <div class="container-fluid px-4 mt-4 mb-5">

                    <!-- HEADER -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <a href="dashboard" class="btn btn-outline-secondary btn-sm mb-2 shadow-sm">
                                <i class="fa-solid fa-arrow-left"></i> Dashboard
                            </a>
                            <h3 class="text-uppercase fw-bold text-dark">
                                <i class="fa-solid fa-warehouse text-primary"></i> Kho Hàng
                            </h3>
                        </div>
                        <span class="badge bg-white text-primary border border-primary fs-6 shadow-sm p-2">
                            Tổng sách: ${listB.size()}
                        </span>
                    </div>

                    <!-- FILTER -->
                    <div class="filter-box">
                        <form action="inventory" method="get">
                            <div class="row g-2 align-items-end">

                                <div class="col-md-3">
                                    <label class="form-label fw-bold small text-secondary">Tên sách</label>
                                    <input type="text" name="search" class="form-control" placeholder="Nhập tên..."
                                        value="${paramSearch}">
                                </div>

                                <div class="col-md-2">
                                    <label class="form-label fw-bold small text-secondary">Thể loại</label>
                                    <select name="cid" class="form-select">
                                        <option value="0">-- Tất cả --</option>
                                        <option value="1" ${paramCid==1 ? 'selected' : '' }>Kinh tế</option>
                                        <option value="2" ${paramCid==2 ? 'selected' : '' }>Văn học</option>
                                        <option value="3" ${paramCid==3 ? 'selected' : '' }>Thiếu nhi</option>
                                        <option value="4" ${paramCid==4 ? 'selected' : '' }>Công nghệ</option>
                                        <option value="5" ${paramCid==5 ? 'selected' : '' }>Kỹ năng sống</option>
                                    </select>
                                </div>

                                <div class="col-md-2">
                                    <label class="form-label fw-bold small text-secondary">Tác giả</label>
                                    <select name="author" class="form-select">
                                        <option value="">-- Tất cả --</option>
                                        <c:forEach items="${listAuthors}" var="a">
                                            <option value="${a}" ${paramAuthor==a ? 'selected' : '' }>${a}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-2">
                                    <label class="form-label fw-bold small text-secondary">NXB</label>
                                    <select name="publisher" class="form-select">
                                        <option value="">-- Tất cả --</option>
                                        <c:forEach items="${listPublishers}" var="p">
                                            <option value="${p}" ${paramPublisher==p ? 'selected' : '' }>${p}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-2">
                                    <label class="form-label fw-bold small text-secondary">Mức giá</label>
                                    <select name="priceRange" class="form-select">
                                        <option value="">-- Tất cả --</option>
                                        <option value="under100" ${paramPrice=='under100' ? 'selected' : '' }>&lt; 100k
                                        </option>
                                        <option value="100-200" ${paramPrice=='100-200' ? 'selected' : '' }>100k - 200k
                                        </option>
                                        <option value="200-500" ${paramPrice=='200-500' ? 'selected' : '' }>200k - 500k
                                        </option>
                                        <option value="over500" ${paramPrice=='over500' ? 'selected' : '' }>&gt; 500k
                                        </option>
                                    </select>
                                </div>

                                <div class="col-md-1">
                                    <button class="btn btn-primary w-100">
                                        <i class="fa-solid fa-filter"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- giữ sort khi filter -->
                            <input type="hidden" name="sort" value="${param.sort}">
                            <input type="hidden" name="order" value="${param.order}">
                        </form>
                    </div>

                    <!-- TABLE -->
                    <div class="table-container">
                        <table class="table table-hover table-striped mb-0">

                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Ảnh</th>

                                    <!-- TITLE -->
                                    <th>
                                        <a class="sort-link" href="inventory?sort=title&order=${param.order == 'ASC' ? 'DESC' : 'ASC'}
                       &search=${paramSearch}&cid=${paramCid}&author=${paramAuthor}
                       &publisher=${paramPublisher}&priceRange=${paramPrice}">
                                            Tên sách
                                            <i
                                                class="fa-solid fa-sort sort-icon ${param.sort == 'title' ? 'active-sort' : ''}"></i>
                                        </a>
                                    </th>

                                    <!-- AUTHOR -->
                                    <th>
                                        <a class="sort-link" href="inventory?sort=author&order=${param.order == 'ASC' ? 'DESC' : 'ASC'}
                       &search=${paramSearch}&cid=${paramCid}&author=${paramAuthor}
                       &publisher=${paramPublisher}&priceRange=${paramPrice}">
                                            Tác giả
                                            <i
                                                class="fa-solid fa-sort sort-icon ${param.sort == 'author' ? 'active-sort' : ''}"></i>
                                        </a>
                                    </th>

                                    <!-- PUBLISHER -->
                                    <th>
                                        <a class="sort-link" href="inventory?sort=publisher&order=${param.order == 'ASC' ? 'DESC' : 'ASC'}
                       &search=${paramSearch}&cid=${paramCid}&author=${paramAuthor}
                       &publisher=${paramPublisher}&priceRange=${paramPrice}">
                                            NXB
                                            <i
                                                class="fa-solid fa-sort sort-icon ${param.sort == 'publisher' ? 'active-sort' : ''}"></i>
                                        </a>
                                    </th>

                                    <!-- PRICE -->
                                    <th>
                                        <a class="sort-link" href="inventory?sort=price&order=${param.order == 'ASC' ? 'DESC' : 'ASC'}
                       &search=${paramSearch}&cid=${paramCid}&author=${paramAuthor}
                       &publisher=${paramPublisher}&priceRange=${paramPrice}">
                                            Giá
                                            <i
                                                class="fa-solid fa-sort sort-icon ${param.sort == 'price' ? 'active-sort' : ''}"></i>
                                        </a>
                                    </th>

                                    <!-- STOCK -->
                                    <th class="text-center">
                                        <a class="sort-link justify-content-center" href="inventory?sort=stock_quantity&order=${param.order == 'ASC' ? 'DESC' : 'ASC'}
                       &search=${paramSearch}&cid=${paramCid}&author=${paramAuthor}
                       &publisher=${paramPublisher}&priceRange=${paramPrice}">
                                            Tồn
                                            <i
                                                class="fa-solid fa-sort sort-icon ${param.sort == 'stock_quantity' ? 'active-sort' : ''}"></i>
                                        </a>
                                    </th>

                                    <th class="text-center">Trạng thái</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach items="${listB}" var="b" varStatus="loop">
                                    <tr>
                                        <td>${loop.count}</td>
                                        <td>
                                            <img class="book-img"
                                                src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}"
                                                onerror="this.src='https://placehold.co/45x65?text=Img'">
                                        </td>
                                        <td>
                                            <span class="fw-bold text-dark d-block text-truncate"
                                                style="max-width: 250px;" title="${b.title}">
                                                ${b.title}
                                            </span>
                                        </td>

                                        <td>${b.author}</td>
                                        <td>${b.publisher}</td>
                                        <td class="text-danger fw-bold">
                                            <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ"
                                                maxFractionDigits="0" />
                                        </td>
                                        <td class="text-center fw-bold">${b.stockQuantity}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${b.stockQuantity == 0}">
                                                    <span class="badge bg-secondary status-badge">Hết hàng</span>
                                                </c:when>
                                                <c:when test="${b.stockQuantity < 5}">
                                                    <span class="badge bg-warning text-dark status-badge">Sắp hết</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success status-badge">Có sẵn</span>
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