<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Category | Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 1. FIX THE FONT GLOBALLY */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
            background-color: #f4f6f9;
        }

        .form-container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        h2 {
            font-family: 'Segoe UI', sans-serif !important; /* Force clean font */
            text-align: center; 
            margin-bottom: 30px;
            color: #333;
            font-weight: 700;
        }

        .form-group { margin-bottom: 25px; }
        
        .form-label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #555;
            font-family: 'Segoe UI', sans-serif !important;
        }
        
        .form-control { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid #ddd; 
            border-radius: 6px; 
            font-size: 15px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: #28a745;
            outline: none;
        }

        /* Styling for the Description Box */
        textarea.form-control {
            resize: vertical; /* Allow user to resize height */
            min-height: 100px;
        }

        .btn-submit { 
            background-color: #28a745; 
            color: white; 
            border: none; 
            padding: 12px 20px; 
            border-radius: 6px; 
            cursor: pointer; 
            width: 100%; 
            font-size: 16px; 
            font-weight: 600;
            transition: background 0.3s;
        }
        
        .btn-submit:hover { background-color: #218838; }
        
        .back-link { 
            display: block; 
            margin-top: 20px; 
            text-align: center; 
            color: #6c757d; 
            text-decoration: none; 
            font-weight: 500;
        }
        .back-link:hover { text-decoration: underline; color: #333; }
    </style>
</head>
<body>

    <div class="form-container">
        <h2>Add New Category</h2>
        
        <form action="add" method="post">
            <div class="form-group">
                <label class="form-label">Category Name</label>
                <input type="text" name="name" class="form-control" placeholder="e.g. Science Fiction" required>
            </div>

            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" placeholder="Describe this category..."></textarea>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fa-solid fa-plus"></i> Add Category
            </button>
            
            <a href="${pageContext.request.contextPath}/admin/product/list" class="back-link">Cancel</a>
        </form>
    </div>

</body>
</html>