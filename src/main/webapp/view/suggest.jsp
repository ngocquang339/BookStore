<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gợi ý cho bạn - MINDBOOK</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body style="background-color: #f0f0f0; margin: 0; font-family: sans-serif;">

    <jsp:include page="component/header.jsp" />

    <main class="container-fluid" style="max-width: 1250px; margin: 20px auto 50px auto;">
        
        <div class="white-box" style="background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
            <h2 style="text-transform: uppercase; color: #333; margin-top: 0; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #55C779;">
                <i class="fa-solid fa-sparkles" style="color: #55C779;"></i> Tất cả Gợi ý cho bạn
            </h2>

            <div style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px;">
                <c:forEach items="${allSuggestedBooks}" var="b">
                    <a href="${pageContext.request.contextPath}/detail?id=${b.id}" style="text-decoration: none; color: inherit; display: block; padding: 10px; border-radius: 8px; border: 1px solid #eee;" onmouseover="this.style.boxShadow='0 0 10px rgba(0,0,0,0.1)'" onmouseout="this.style.boxShadow='none'">
                        <div class="product-card" style="display: flex; flex-direction: column;">
                            <div style="height: 200px; display: flex; justify-content: center; align-items: center; margin-bottom: 10px;">
                                <img src="${pageContext.request.contextPath}/${b.imageUrl}" alt="${b.title}" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                            </div>
                            <div style="font-size: 14px; color: #333; height: 38px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; margin-bottom: 8px;">${b.title}</div>
                            <div style="color: #C92127; font-size: 16px; font-weight: bold; margin-bottom: 5px;"><fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                        </div>
                    </a>
                </c:forEach>
            </div>
            
        </div>

    </main>

    <jsp:include page="component/footer.jsp" />

</body>
</html>