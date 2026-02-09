<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>

<body>
    
    <jsp:include page="component/header.jsp" />

    <c:if test="${not empty sessionScope.mess}">
        <div class="toast-message ${sessionScope.status == 'success' ? 'toast-success' : 'toast-error'}" id="toastMsg">
            <i class="fa-solid ${sessionScope.status == 'success' ? 'fa-circle-check' : 'fa-circle-exclamation'}" style="font-size: 24px;"></i>
            <div>
                <h6 style="margin:0; font-weight:bold;">Thông báo</h6>
                <p style="margin:0; font-size:13px;">${sessionScope.mess}</p>
            </div>
        </div>
        <c:remove var="mess" scope="session" />
        <c:remove var="status" scope="session" />
    </c:if>

    <div class="container profile-container">
        <div class="row">
            
            <div class="col-md-3">
                <jsp:include page="component/sidebar.jsp" />
            </div>

            <div class="col-md-9">
                <div class="main-profile-content">
                    
                    <div class="page-header">
                        <h5>Đổi mật khẩu</h5>
                        <p style="font-size: 13px; color: #666; margin:0;">Để bảo mật tài khoản, vui lòng không chia sẻ mật khẩu cho người khác</p>
                    </div>

                    <form action="change-password" method="post">
                        
                        <div class="form-row">
                            <label class="form-label-custom">Mật khẩu hiện tại<span class="text-danger">*</span></label>
                            <div class="form-input-custom">
                                <input type="password" name="currentPass" class="form-control" placeholder="Nhập mật khẩu hiện tại" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom">Mật khẩu mới<span class="text-danger">*</span></label>
                            <div class="form-input-custom">
                                <input type="password" name="newPass" class="form-control" placeholder="Nhập mật khẩu mới" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom">Xác nhận mật khẩu<span class="text-danger">*</span></label>
                            <div class="form-input-custom">
                                <input type="password" name="confirmPass" class="form-control" placeholder="Nhập lại mật khẩu mới" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom"></label>
                            <div class="form-input-custom">
                                <button type="submit" class="btn-save-pass">Lưu thay đổi</button>
                            </div>
                        </div>

                    </form>

                </div>
            </div> </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        setTimeout(function() {
            let toast = document.getElementById('toastMsg');
            if (toast) toast.style.display = 'none';
        }, 4000);
    </script>
</body>
</html>