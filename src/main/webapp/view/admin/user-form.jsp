<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Add New User</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-form.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <div class="form-container">
        <h2><i class="fa-solid fa-user-plus"></i> Create New User</h2>
        
        <c:if test="${not empty error}">
            <div style="background:#f8d7da; color:#721c24; padding:10px; margin-bottom:15px; border-radius:4px;">
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/users/add" method="post">
            
            <div class="form-row">
                <div class="form-group">
                    <label>Username <span style="color:red">*</span></label>
                    <input type="text" class="form-control" name="username" required>
                </div>
                <div class="form-group">
                    <label>Password <span style="color:red">*</span></label>
                    <input type="password" class="form-control" name="password" required>
                </div>
            </div>

            <div class="form-group">
                <label>Full Name</label>
                <input type="text" class="form-control" name="fullname" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Email <span style="color:red">*</span></label>
                    <input type="email" class="form-control" name="email" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" class="form-control" name="phone">
                </div>
            </div>
            
            <div class="form-group">
                <label>Address</label>
                <input type="text" class="form-control" name="address">
            </div>

            <div class="form-group">
                <label>Role</label>
                <select class="form-control" name="role">
                    <option value="2">Customer (Default)</option>
                    <option value="4">Warehouse Manager</option>
                    <option value="1">Admin</option>
                </select>
                <small style="color: #666;">Be careful when assigning Admin privileges.</small>
            </div>

            <div style="text-align: right; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn-cancel">Cancel</a>
                <button type="submit" class="btn-submit">Create User</button>
            </div>
        </form>
    </div>

</body>
</html>