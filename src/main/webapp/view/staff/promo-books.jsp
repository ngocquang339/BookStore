<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Sách vào Khuyến Mãi - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f4f6f9; }
        .main-content { padding: 20px; }
        .white-box { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        /* Tùy chỉnh công tắc to hơn 1 chút cho dễ bấm */
        .form-switch .form-check-input { width: 3em; height: 1.5em; cursor: pointer; }
    </style>
</head>
<body>

    <div class="container-fluid main-content">
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/staff/promotions" class="text-decoration-none text-secondary">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Danh sách
            </a>
        </div>

        <div class="white-box mb-4 bg-danger text-white">
            <h3 class="fw-bold mb-1"><i class="fa-solid fa-bolt me-2"></i>${promo.promoName}</h3>
            <p class="mb-0 fs-5">Mức giảm: <strong>-${promo.discountPercent}%</strong> | Thời hạn: <fmt:formatDate value="${promo.startDate}" pattern="dd/MM/yyyy HH:mm" /> đến <fmt:formatDate value="${promo.endDate}" pattern="dd/MM/yyyy HH:mm" /></p>
        </div>

        <div class="white-box">
            <h5 class="fw-bold mb-3">Danh Sách Sách Trong Hệ Thống</h5>
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Hình Ảnh</th>
                        <th>Tên Sách</th>
                        <th>Giá Gốc</th>
                        <th>Tồn Kho</th>
                        <th class="text-center">Tham Gia Flash Sale</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${allBooks}" var="b">
                        <c:set var="isSelected" value="false" />
                        <c:forEach items="${selectedBookIds}" var="selId">
                            <c:if test="${selId == b.id}">
                                <c:set var="isSelected" value="true" />
                            </c:if>
                        </c:forEach>

                        <tr>
                            <td>#${b.id}</td>
                            <td><img src="${pageContext.request.contextPath}/${b.imageUrl}" width="50" style="object-fit: cover;"></td>
                            <td class="fw-bold">${b.title}</td>
                            <td><fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0" /></td>
                            <td>${b.stockQuantity}</td>
                            <td class="text-center">
                                <div class="form-check form-switch d-flex justify-content-center">
                                    <input class="form-check-input toggle-promo-btn" type="checkbox" 
                                           data-bookid="${b.id}" 
                                           ${isSelected ? 'checked' : ''}>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation" class="mt-4">
                <ul class="pagination justify-content-center">
                    
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?id=${promo.promoId}&page=${currentPage - 1}">Trang trước</a>
                    </li>
                    
                    <c:set var="startPage" value="${currentPage - 2}" />
                    <c:set var="endPage" value="${currentPage + 2}" />

                    <c:if test="${startPage < 1}">
                        <c:set var="startPage" value="1" />
                        <c:set var="endPage" value="${totalPages > 5 ? 5 : totalPages}" />
                    </c:if>

                    <c:if test="${endPage > totalPages}">
                        <c:set var="endPage" value="${totalPages}" />
                        <c:set var="startPage" value="${totalPages - 4 > 0 ? totalPages - 4 : 1}" />
                    </c:if>

                    <c:if test="${startPage > 1}">
                        <li class="page-item"><a class="page-link" href="?id=${promo.promoId}&page=1">1</a></li>
                        <c:if test="${startPage > 2}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        </c:if>
                    </c:if>

                    <c:forEach begin="${startPage}" end="${endPage}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="?id=${promo.promoId}&page=${i}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${endPage < totalPages}">
                        <c:if test="${endPage < totalPages - 1}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        </c:if>
                        <li class="page-item"><a class="page-link" href="?id=${promo.promoId}&page=${totalPages}">${totalPages}</a></li>
                    </c:if>

                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?id=${promo.promoId}&page=${currentPage + 1}">Trang sau</a>
                    </li>
                    
                </ul>
            </nav>
        </c:if>
    </div>

    <script>
        const promoId = ${promo.promoId}; // ID của đợt sale hiện tại

        document.querySelectorAll('.toggle-promo-btn').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                const bookId = this.getAttribute('data-bookid');
                // Nếu công tắc đang bật -> hành động là add, nếu tắt -> hành động là remove
                const action = this.checked ? 'add' : 'remove';
                
                // Vô hiệu hóa công tắc tạm thời trong lúc chờ Server
                this.disabled = true;

                // Gửi dữ liệu ngầm xuống PromoBookServlet (POST)
                const data = new URLSearchParams();
                data.append('action', action);
                data.append('promoId', promoId);
                data.append('bookId', bookId);

                fetch('${pageContext.request.contextPath}/staff/promo-books', {
                    method: 'POST',
                    body: data,
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                })
                .then(res => res.json())
                .then(result => {
                    if (!result.success) {
                        alert("Có lỗi xảy ra, không thể cập nhật DB!");
                        this.checked = !this.checked; // Bật/tắt lại như cũ nếu bị lỗi
                    }
                })
                .catch(err => {
                    console.error("Lỗi mạng:", err);
                    this.checked = !this.checked;
                })
                .finally(() => {
                    this.disabled = false; // Mở khóa công tắc
                });
            });
        });
    </script>
</body>
</html>