<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông báo của tôi - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>
<body>
    
    <jsp:include page="component/header.jsp" />

    <div class="container profile-container py-4">
        <div class="row">
            
            <%-- Cột trái: Sidebar --%>
            <div class="col-md-3">
                <jsp:include page="component/sidebar.jsp" />
            </div>

            <%-- Cột phải: Danh sách Thông báo --%>
            <div class="col-md-9">
                <div class="main-profile-content bg-white p-4" style="border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
                    
                    <%-- Tiêu đề và nút Xóa tất cả --%>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold mb-0" style="color: #333; text-transform: uppercase;">
                            <i class="fa-regular fa-bell text-danger me-2"></i> Tất cả thông báo
                        </h5>
                        
                        <%-- Nút Xóa tất cả (Chỉ hiện khi có ít nhất 1 thông báo) --%>
                        <c:if test="${not empty listNotif}">
                            <button onclick="removeAllNotifications()" class="btn btn-sm btn-outline-danger fw-bold" style="border-radius: 6px;">
                                <i class="fa-solid fa-trash-can me-1"></i> Xóa tất cả
                            </button>
                        </c:if>
                    </div>

                    <c:choose>
                        <c:when test="${empty listNotif}">
                            <div class="text-center py-5">
                                <i class="fa-solid fa-box-open text-muted mb-3" style="font-size: 50px; opacity: 0.3;"></i>
                                <h6 class="text-muted fw-bold">Chưa có thông báo nào</h6>
                                <p style="font-size: 14px; color: #888;">Bạn sẽ nhận được thông báo khi có người tương tác hoặc nhắc đến bạn.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group">
                                <c:forEach var="n" items="${listNotif}">
                                    <a href="javascript:void(0);" 
                                       onclick="readAndRedirect(${n.id}, '${pageContext.request.contextPath}/${n.link}')"
                                       class="list-group-item list-group-item-action p-3 mb-2 d-flex align-items-center justify-content-between"
                                       style="border-radius: 8px; border: 1px solid #eee; ${n.isRead ? 'background-color: #fff;' : 'background-color: #f4faff; border-left: 4px solid #C92127;'}">
                                        
                                        <%-- Phía bên trái: Icon + Nội dung --%>
                                        <div class="d-flex align-items-start" style="flex: 1;">
                                            <div class="me-3 mt-1 ${n.isRead ? 'text-secondary' : 'text-primary'}">
                                                <i class="fa-solid fa-comment-dots" style="font-size: 20px;"></i>
                                            </div>
                                            <div>
                                                <div style="font-size: 15px; color: #333; margin-bottom: 5px;">${n.message}</div>
                                                <div style="font-size: 12px; color: #888;">
                                                    <i class="fa-regular fa-clock me-1"></i>
                                                    <fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <%-- Phía bên phải: Chấm đỏ (nếu chưa đọc) + Nút Xóa --%>
                                        <div class="d-flex align-items-center gap-3">
                                            <c:if test="${!n.isRead}">
                                                <div style="width: 10px; height: 10px; background-color: #C92127; border-radius: 50%;"></div>
                                            </c:if>
                                            
                                            <%-- Nút Thùng Rác (Gọi hàm xóa và chặn event nhảy trang) --%>
                                            <div onclick="removeNotification(event, ${n.id})" 
                                                 class="text-muted p-2" 
                                                 style="cursor: pointer; transition: 0.2s;" 
                                                 onmouseover="this.className='text-danger p-2'" 
                                                 onmouseout="this.className='text-muted p-2'" 
                                                 title="Xóa thông báo">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>

                            <%-- Phân trang --%>
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation" class="mt-4">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item"><a class="page-link" href="notifications?page=${currentPage - 1}" style="color: #C92127;">&laquo; Trước</a></li>
                                        </c:if>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="notifications?page=${i}" style="${currentPage == i ? 'background-color: #C92127; border-color: #C92127; color: white;' : 'color: #C92127;'}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item"><a class="page-link" href="notifications?page=${currentPage + 1}" style="color: #C92127;">Sau &raquo;</a></li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
            
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function removeNotification(event, notifId) {
            // 1. NGĂN CHẶN thẻ <a> thực hiện lệnh readAndRedirect()
            event.preventDefault();
            event.stopPropagation();
            
            // 2. Hiện bảng hỏi xác nhận
            if (confirm("Bạn có chắc chắn muốn xóa thông báo này?")) {
                // 3. Gọi Servlet bằng AJAX để xóa
                fetch('${pageContext.request.contextPath}/notification', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'action=deleteNotif&notifId=' + notifId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Xóa thành công thì tải lại trang để thấy danh sách mới
                        window.location.reload();
                    } else {
                        alert("Đã xảy ra lỗi khi xóa thông báo!");
                    }
                })
                .catch(err => console.error("Lỗi xóa thông báo:", err));
            }
        }

        function removeAllNotifications() {
            // Hiện cảnh báo cấp độ cao vì đây là hành động xóa toàn bộ
            if (confirm("⚠️ Bạn có CHẮC CHẮN muốn xóa TOÀN BỘ thông báo không?\nHành động này không thể hoàn tác!")) {
                
                fetch('${pageContext.request.contextPath}/notification', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'action=deleteAllNotif' // Không cần gửi notifId, Servlet tự lấy user từ Session
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        window.location.reload(); // Xóa xong tải lại trang sẽ tự ra cái hòm rỗng
                    } else {
                        alert("Đã xảy ra lỗi khi xóa thông báo!");
                    }
                })
                .catch(err => console.error("Lỗi xóa thông báo:", err));
            }
        }
    </script>
</body>
</html>