<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ của ${targetUser.username} - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    
    <style>
        body {
            background-color: #f9f9f9; /* Nền xám nhạt để làm nổi bật thẻ trắng */
        }
        
        /* =========================================
           STYLE MỚI CHO PROFILE HEADER
           ========================================= */
        .public-profile-header-wrap {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            margin-bottom: 40px;
            border: 1px solid #f0f0f0;
        }

        /* Dải màu nền (Cover) giống ảnh bìa Facebook */
        .profile-cover {
            height: 140px;
            /* Đổ màu gradient đỏ nhạt sang hồng pastel */
            background: linear-gradient(135deg, #fff0f0 0%, #ffe3e3 100%);
            position: relative;
        }

        /* Khối chứa Avatar và Thông tin (Kéo lùi lên trên ảnh bìa) */
        .profile-info-section {
            padding: 0 20px 30px;
            text-align: center;
            position: relative;
            margin-top: -60px; /* Chìa khóa để avatar nổi lên giữa 2 khối */
        }

        .big-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: #C92127;
            color: white;
            font-size: 50px;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 5px solid #fff; /* Viền trắng dày tạo khối */
            box-shadow: 0 4px 15px rgba(201, 33, 39, 0.25);
            text-transform: uppercase;
            position: relative;
            z-index: 2;
        }

        /* Phần Thống kê lấp khoảng trống */
        .profile-stats {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px dashed #eee;
            width: fit-content;
            margin-left: auto;
            margin-right: auto;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            min-width: 100px;
        }

        .stat-num {
            font-size: 22px;
            font-weight: 800;
            color: #C92127;
            line-height: 1.2;
        }

        .stat-label {
            font-size: 13px;
            color: #777;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 500;
        }

        .stat-divider {
            width: 1px;
            background-color: #eee;
            height: 40px;
        }
        
        /* 2. Thẻ Bộ sưu tập (Read-only) */
        .collection-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.06);
            overflow: hidden;
            height: 100%;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 1px solid #f0f0f0;
            display: flex;
            flex-direction: column;
        }
        
        .collection-card:hover {
            transform: translateY(-8px); /* Hiệu ứng nảy lên khi di chuột */
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        
        .collection-color-bar {
            height: 8px;
            width: 100%;
        }
        
        .collection-body {
            padding: 25px 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        
        .collection-title {
            font-size: 19px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
            transition: color 0.3s;
        }
        
        .collection-desc {
            font-size: 14.5px;
            color: #666;
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 2; /* Giới hạn 2 dòng */
            -webkit-box-orient: vertical;
            overflow: hidden;
            flex-grow: 1;
        }
        
        .collection-footer {
            border-top: 1px dashed #eee;
            padding-top: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>
</head>

<body>
    <jsp:include page="component/header.jsp" />

    <div class="container py-5">
        
        <div class="public-profile-header-wrap">
            <div class="profile-cover"></div>
            
            <div class="profile-info-section">
                <div class="big-avatar">
                    ${targetUser.username.substring(0, 1).toUpperCase()}
                </div>
                
                <h2 class="fw-bold mb-1 text-dark" style="letter-spacing: -0.5px;">${targetUser.username}</h2>
                <p class="text-muted mb-0" style="font-size: 15px;">
                    <i class="fa-solid fa-book-open-reader me-1" style="color: #C92127;"></i> Thành viên yêu sách
                </p>
                
                <div class="profile-stats d-flex justify-content-center gap-4 align-items-center">
                    <div class="stat-item">
                        <span class="stat-num">${publicCollections.size()}</span>
                        <span class="stat-label mt-1">Bộ sưu tập</span>
                    </div>
                    
                    <div class="stat-divider"></div>
                    
                    <div class="stat-item">
                        <span class="stat-num"><i class="fa-solid fa-seedling"></i></span>
                        <span class="stat-label mt-1">Độc giả tích cực</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold m-0" style="color: #333;">
                <i class="fa-solid fa-swatchbook me-2" style="color: #C92127;"></i>
                Góc chia sẻ của ${targetUser.username}
            </h4>
        </div>

        <div class="row">
            <c:choose>
                <%-- Trạng thái rỗng: Nếu user này không có BST nào công khai --%>
                <c:when test="${empty publicCollections}">
                    <div class="col-12 text-center py-5" style="background: #fff; border-radius: 12px; border: 1px dashed #ddd;">
                        <i class="fa-solid fa-folder-open text-muted mb-3" style="font-size: 70px; opacity: 0.2;"></i>
                        <h5 class="text-muted fw-bold">Trống vắng quá!</h5>
                        <p class="text-muted">Người dùng này chưa có bộ sưu tập nào được đặt ở chế độ Công khai.</p>
                        
                        <a href="javascript:history.back()" class="btn btn-outline-secondary mt-3">
                            <i class="fa-solid fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </c:when>
                
                <%-- Trạng thái có dữ liệu: Hiển thị các Card --%>
                <c:otherwise>
                    <c:forEach var="c" items="${publicCollections}">
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="collection-card">
                                <div class="collection-color-bar" style="background-color: ${c.coverColor};"></div>
                                
                                <div class="collection-body">
                                    <a href="${pageContext.request.contextPath}/collection-detail?id=${c.id}" style="text-decoration: none;">
                                        <div class="collection-title" onmouseover="this.style.color='${c.coverColor}'" onmouseout="this.style.color='#333'">
                                            ${c.name}
                                        </div>
                                    </a>
                                    
                                    <div class="collection-desc">
                                        ${empty c.description ? '<i>Không có mô tả cho giá sách này.</i>' : c.description}
                                    </div>
                                    
                                    <div class="collection-footer">
                                        <span class="badge rounded-pill bg-light text-success border border-success" style="font-weight: 500;">
                                            <i class="fa-solid fa-earth-americas me-1"></i> Công khai
                                        </span>
                                        
                                        <a href="${pageContext.request.contextPath}/collection-detail?id=${c.id}" class="btn btn-sm btn-outline-danger" style="border-radius: 20px; font-weight: bold;">
                                            Khám phá
                                        </a>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <jsp:include page="component/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>