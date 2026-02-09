<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ của ${sessionScope.user.username} - BookStore</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    
    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css"> -->

    <style>
        /* Style cho thông báo thành công */
        .toast-message {
            position: fixed;
            top: 80px; /* Cách mép trên */
            right: 20px; /* Cách mép phải */
            background-color: #ffffff;
            color: #155724; /* Chữ xanh đậm */
            border-left: 5px solid #28a745; /* Viền trái màu xanh lá */
            padding: 15px 25px;
            border-radius: 4px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            display: flex;
            align-items: center;
            gap: 15px;
            z-index: 9999;
            animation: slideIn 0.5s ease forwards, fadeOut 0.5s ease 3s forwards;
            opacity: 0; /* Mặc định ẩn để chờ animation */
            min-width: 300px;
        }

        .toast-message i {
            font-size: 24px;
            color: #28a745; /* Icon màu xanh lá */
        }

        .toast-content h4 {
            margin: 0;
            font-size: 16px;
            font-weight: bold;
        }

        .toast-content p {
            margin: 0;
            font-size: 14px;
            color: #666;
        }

        /* Hiệu ứng bay vào */
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        /* Hiệu ứng mờ dần sau 3 giây */
        @keyframes fadeOut {
            to { opacity: 0; visibility: hidden; }
        }
    </style>
</head>

<body>
    
    <jsp:include page="component/header.jsp" />

    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>

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
                        <h5>Hồ sơ cá nhân</h5>
                        <p style="font-size: 13px; color: #666; margin:0;">Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/update-profile" method="post">
                        
                        <div class="form-row">
                            <label class="form-label-custom">Tên đăng nhập</label>
                            <div class="form-input-custom">
                                <input type="text" name="username" value="${sessionScope.user.username}" class="form-control" readonly title="Không thể thay đổi tên đăng nhập">
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom">Họ và tên</label>
                            <div class="form-input-custom">
                                <input type="text" name="fullname" value="${sessionScope.user.fullname}" class="form-control" placeholder="Nhập họ tên đầy đủ">
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom">Email</label>
                            <div class="form-input-custom">
                                <input type="email" name="email" value="${sessionScope.user.email}" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom">Số điện thoại</label>
                            <div class="form-input-custom">
                                <input type="text" name="phone_number" value="${sessionScope.user.phone_number}" class="form-control" placeholder="Nhập số điện thoại">
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom">Địa chỉ nhận hàng</label>
                            <div class="form-input-custom">
                                <input type="text" name="address" value="${sessionScope.user.address}" class="form-control" placeholder="Nhập địa chỉ nhận hàng">
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom"></label> <div class="form-input-custom">
                                <button type="submit" class="btn-save-pass">
                                    <i class="fa-regular fa-floppy-disk"></i> Lưu thay đổi
                                </button>
                            </div>
                        </div>

                    </form>
                </div>
            </div> </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Tự động xóa element sau khi chạy xong hiệu ứng fadeOut
        setTimeout(function() {
            let toast = document.getElementById('successToast');
            if (toast) {
                toast.remove();
            }
        }, 4000); // 4000ms = 4 giây
    </script>
</body>
</html>