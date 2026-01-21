<main class="main-content container">
        <h2 style="margin-top: 20px;">Danh sách Sách</h2>

        <c:if test="${not empty txtS}">
            <p>Kết quả tìm kiếm cho: <b>"${txtS}"</b></p>
        </c:if>

        <c:if test="${empty listBooks}">
            <div style="text-align: center; color: red; margin: 20px;">
                <h3>Không tìm thấy sản phẩm nào!</h3>
            </div>
        </c:if>

        <div class="product-list">
            <c:forEach items="${listBooks}" var="b">
                <div class="product-card">
                    
                    <img src="${empty b.imageUrl ? 'https://via.placeholder.com/150' : b.imageUrl}" alt="${b.title}">
                    
                    <h3>${b.title}</h3>
                    
                    <p class="price">${b.price} đ</p>
                    
                    <div style="margin: 10px 0; font-size: 13px;">
                        <c:choose>
                            <c:when test="${b.stockQuantity == 0}">
                                <span style="color: red; font-weight: bold;">Hết hàng</span>
                            </c:when>
                            <c:when test="${b.stockQuantity < 5}">
                                <span style="color: orange;">Sắp hết (Còn ${b.stockQuantity})</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: green;">Sẵn hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <a href="detail?pid=${b.id}" style="color: blue;">Xem chi tiết</a>
                </div>
            </c:forEach>
        </div>
    </main>