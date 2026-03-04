<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="suggested-box white-box" style="padding: 0; border-radius: 8px; margin-top: 30px; overflow: hidden; background: white; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
    
    <div style="background-color: #55C779; padding: 15px; text-align: center; color: white; font-size: 20px; font-weight: bold; text-transform: uppercase;">
        <i class="fa-solid fa-sparkles"></i> Gợi ý cho bạn <i class="fa-solid fa-sparkles"></i>
    </div>

    <div style="padding: 20px; display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px;">
        
        <c:forEach items="${suggestedBooks}" var="b">
            <a href="${pageContext.request.contextPath}/detail?pid=${b.id}" style="text-decoration: none; color: inherit; display: block; padding: 10px; transition: 0.3s; border-radius: 8px;" 
               onmouseover="this.style.boxShadow='0 0 10px rgba(0,0,0,0.1)'" 
               onmouseout="this.style.boxShadow='none'">
                
                <div class="product-card" style="display: flex; flex-direction: column;">
                    
                    <div style="height: 200px; display: flex; justify-content: center; align-items: center; margin-bottom: 10px;">
                        <img src="${pageContext.request.contextPath}/${b.imageUrl}" alt="${b.title}" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                    </div>

                    <div style="font-size: 14px; color: #333; line-height: 1.4; height: 38px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; margin-bottom: 8px;">
                        ${b.title}
                    </div>

                    <div style="display: flex; align-items: center; flex-wrap: wrap; gap: 5px; margin-bottom: 5px;">
                        <span style="color: #C92127; font-size: 16px; font-weight: bold;">
                            <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </span>
                        <span style="background: #C92127; color: white; font-size: 12px; padding: 2px 4px; border-radius: 3px;">-20%</span>
                    </div>

                    <div style="color: #999; font-size: 13px; text-decoration: line-through; margin-bottom: 5px;">
                        <fmt:formatNumber value="${b.price * 1.2}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </div>
                </div>
            </a>
        </c:forEach>
        </div> <div style="text-align: center; padding-bottom: 25px; margin-top: 10px;">
        <a href="${pageContext.request.contextPath}/suggest-book" 
           style="display: inline-block; padding: 8px 40px; border: 1px solid #C92127; color: #C92127; font-weight: bold; text-decoration: none; border-radius: 4px; font-size: 14px; transition: 0.3s;"
           onmouseover="this.style.background='#C92127'; this.style.color='white';" 
           onmouseout="this.style.background='white'; this.style.color='#C92127';">
            Xem tất cả <i class="fa-solid fa-angle-right" style="margin-left: 5px;"></i>
        </a>
    </div>
    </div>