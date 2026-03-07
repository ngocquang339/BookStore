<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sổ địa chỉ - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        /* Tận dụng lại background trắng và bo góc để khớp với class .main-profile-content nếu có */
        .address-wrapper {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08); /* Đổ bóng nhẹ nhàng hơn cho hài hòa với trang */
            padding: 30px;
            color: #333;
        }

        .address-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .address-header h5 {
            margin: 0;
            font-size: 20px; /* Chỉnh lại size chữ cho đồng bộ với H5 của đổi mật khẩu */
            font-weight: 600;
        }
        .btn-add-address {
            color: #2f80ed;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: 0.3s;
        }
        .btn-add-address:hover { text-decoration: underline; }

        .address-item { margin-bottom: 25px; }
        
        .address-info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .address-user {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 15px;
        }
        .address-user .name { font-weight: bold; color: #333; }
        .address-user .separator { color: #ccc; }
        .address-user .phone { font-weight: bold; color: #555; }
        
        .btn-edit {
            color: #2f80ed;
            text-decoration: none;
            font-size: 14px;
            transition: 0.3s;
        }
        .btn-edit:hover { text-decoration: underline; }

        .address-badge {
            display: inline-block;
            background-color: #e6f2ff;
            color: #2f80ed;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 10px;
        }
        .address-user .address-badge {
            margin-bottom: 0;
            margin-left: 5px;
        }

        .address-details { font-size: 14px; color: #666; line-height: 1.6; }
        .address-empty-msg { font-size: 14px; color: #555; }

        .address-divider {
            height: 1px;
            background-color: #f0f0f0;
            border: none;
            margin: 25px 0;
        }

        .address-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .btn-delete {
            color: #d9534f; /* Màu đỏ */
            text-decoration: none;
            font-size: 15px;
            transition: 0.3s;
        }
        .btn-delete:hover { 
            color: #c92127; /* Đỏ đậm hơn khi hover */
        }
    </style>
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
                <div class="address-wrapper">
                    
                    <div class="address-header">
                        <h5>Sổ địa chỉ</h5>
                        <a href="${pageContext.request.contextPath}/add-address" class="btn-add-address">
                            <i class="fa-solid fa-plus"></i> Thêm địa chỉ mới
                        </a>
                    </div>

                    <c:choose>
                        
                        <%-- TRƯỜNG HỢP 1: TÀI KHOẢN CHƯA CÓ BẤT KỲ ĐỊA CHỈ NÀO --%>
                        <c:when test="${empty listAddresses}">
                            <div class="address-item" style="text-align: center; padding: 40px 0;">
                                <div class="address-empty-msg">
                                    Bạn chưa thiết lập địa chỉ nào trong Sổ địa chỉ.
                                </div>
                            </div>
                        </c:when>
                        
                        <%-- TRƯỜNG HỢP 2: ĐĐÃ CÓ ĐỊA CHỈ TRONG DB --%>
                        <c:otherwise>
                            
                            <c:set var="hasDefaultShipping" value="false" />
                            
                            <c:forEach var="addr" items="${listAddresses}">
                                <c:if test="${addr.defaultShipping}">
                                    <c:set var="hasDefaultShipping" value="true" />
                                    
                                    <div class="address-item">
                                        <div class="address-info-row">
                                            <div class="address-user">
                                                <span class="name">${addr.fullName}</span>
                                                <span class="separator">|</span>
                                                <span class="phone">${addr.phone}</span>
                                                <span class="address-badge">Địa chỉ giao hàng mặc định</span>
                                            </div>
                                            
                                            <div class="address-actions">
                                                <a href="${pageContext.request.contextPath}/address?action=edit&id=${addr.id}" class="btn-edit">Sửa</a>
                                                <a href="${pageContext.request.contextPath}/address?action=delete&id=${addr.id}" 
                                                   class="btn-delete" 
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="address-details">
                                            ${addr.addressDetail}<br>
                                            ${addr.ward}, ${addr.district}, ${addr.city}
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>

                            <c:if test="${!hasDefaultShipping}">
                                <div class="address-item">
                                    <span class="address-badge mb-3">Địa chỉ giao hàng mặc định</span>
                                    <div class="address-empty-msg mt-2">
                                        Bạn chưa thiết lập địa chỉ giao hàng mặc định.
                                    </div>
                                </div>
                            </c:if>

                            <hr class="address-divider">

                            <c:set var="hasOtherAddress" value="false" />
                            
                            <c:forEach var="addr" items="${listAddresses}" varStatus="loop">
                                <c:if test="${!addr.defaultShipping}">
                                    <c:set var="hasOtherAddress" value="true" />
                                    
                                    <div class="address-item">
                                        <div class="address-info-row">
                                            <div class="address-user">
                                                <span class="name">${addr.fullName}</span>
                                                <span class="separator">|</span>
                                                <span class="phone">${addr.phone}</span>
                                                
                                                <span class="address-badge" style="background-color: #e6f2ff; color: #2f80ed;">Địa chỉ khác</span>
                                            </div>
                                            
                                            <div class="address-actions">
                                                <a href="${pageContext.request.contextPath}/address?action=edit&id=${addr.id}" class="btn-edit">Sửa</a>
                                                <a href="${pageContext.request.contextPath}/address?action=delete&id=${addr.id}" 
                                                   class="btn-delete" 
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="address-details">
                                            ${addr.addressDetail}<br>
                                            ${addr.ward}, ${addr.district}, ${addr.city}
                                        </div>
                                    </div>
                                    
                                    <c:if test="${!loop.last}">
                                        <hr class="address-divider" style="margin: 15px 0;">
                                    </c:if>
                                </c:if>
                            </c:forEach>

                            <c:if test="${!hasOtherAddress}">
                                <div class="address-item">
                                    <span class="address-badge mb-3" style="background-color: #f0f0f0; color: #555;">Địa chỉ khác</span>
                                    <div class="address-empty-msg mt-2">
                                        Bạn không có địa chỉ khác trong Sổ địa chỉ.
                                    </div>
                                </div>
                            </c:if>

                        </c:otherwise>
                    </c:choose>
                </div> 
            </div> </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Tắt Toast message sau 4s
        setTimeout(function() {
            let toast = document.getElementById('toastMsg');
            if (toast) toast.style.display = 'none';
        }, 4000);
    </script>
</body>
</html>