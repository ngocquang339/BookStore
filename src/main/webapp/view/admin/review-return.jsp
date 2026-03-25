<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>Review Return #${req.returnId}</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    body {
                        background-color: #f4f6f9;
                        font-family: Arial, sans-serif;
                        padding: 20px;
                    }

                    .grid-container {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 20px;
                        margin-top: 20px;
                    }

                    .card {
                        background: white;
                        padding: 20px;
                        border-radius: 8px;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                    }

                    .info-label {
                        color: #666;
                        font-size: 0.9em;
                        margin-bottom: 5px;
                        margin-top: 15px;
                    }

                    .info-value {
                        font-weight: bold;
                        color: #333;
                    }

                    .form-control {
                        width: 100%;
                        padding: 10px;
                        margin-top: 5px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        box-sizing: border-box;
                    }

                    .btn {
                        padding: 10px 15px;
                        border: none;
                        border-radius: 4px;
                        color: white;
                        cursor: pointer;
                        font-weight: bold;
                        margin-top: 15px;
                    }

                    .btn-submit {
                        background-color: #0d6efd;
                    }

                    .btn-back {
                        background-color: #6c757d;
                        text-decoration: none;
                        display: inline-block;
                    }
                </style>
            </head>

            <body>

                <a href="${pageContext.request.contextPath}/admin/returns" class="btn btn-back"><i
                        class="fa-solid fa-arrow-left"></i> Back to List</a>

                <h2 style="margin-top: 20px;">Review Return Request #${req.returnId}</h2>

                <div class="grid-container">
                    <div class="card">
                        <h3 style="margin-top:0; border-bottom: 2px solid #eee; padding-bottom: 10px;">Request Details
                        </h3>

                        <div class="info-label">Customer</div>
                        <div class="info-value">${req.customerName} (Order #${req.orderId})</div>

                        <div class="info-label">Book</div>
                        <div class="info-value">${req.bookTitle} <span style="color: #0d6efd;">(x${req.quantity})</span>
                        </div>

                        <div class="info-label">Logistics Preference</div>
                        <div class="info-value"><i class="fa-solid fa-truck"></i> ${req.returnMethod}</div>

                        

                        <div class="info-label" style="color: #dc3545;">Customer's Stated Reason</div>
                        <div class="info-value"
                            style="background: #f8d7da; padding: 10px; border-radius: 4px; color: #842029;">
                            <i class="fa-solid fa-quote-left"></i> ${req.customerReason}
                        </div>
                    </div>

                    <div class="card">
                        <h3 style="margin-top:0; border-bottom: 2px solid #eee; padding-bottom: 10px;">Evidence &
                            Decision</h3>

                        <div class="info-label">Uploaded Photo</div>
                        <div
                            style="background: #eee; height: 150px; display: flex; align-items: center; justify-content: center; border-radius: 4px; border: 2px dashed #ccc; margin-bottom: 20px;">
                            <span style="color: #888;"><i class="fa-solid fa-image"></i> Awaiting Image System</span>
                        </div>

                        <form action="${pageContext.request.contextPath}/admin/returns/review" method="post">
                            <input type="hidden" name="returnId" value="${req.returnId}">
                            <input type="hidden" name="customerEmail" value="${req.userEmail}">
                            <label class="info-label" style="font-weight: bold; color: #333;">Update Status</label>
                            <select name="status" class="form-control" id="statusDropdown"
                                onchange="toggleDynamicFields()">
                                <option value="1" ${req.status==1 ? 'selected' : '' }>Pending Review</option>
                                <option value="2" ${req.status==2 ? 'selected' : '' }>Action Required (Request Better
                                    Photos)</option>
                                <option value="3" ${req.status==3 ? 'selected' : '' }>Approved (Awaiting Physical Item)
                                </option>
                                <option value="4" ${req.status==4 ? 'selected' : '' }>Failed QC (Item received but
                                    rejected)</option>

                                <option value="5" ${req.status==5 ? 'selected' : '' }>Completed & Refunded (Item
                                    Returned to Store)</option>

                                <option value="7" ${req.status==7 ? 'selected' : '' }>Completed & Refunded (Customer
                                    Keeps Item)</option>

                                <option value="6" ${req.status==6 ? 'selected' : '' }>Rejected Upfront</option>
                            </select>

                            <div id="refundSection"
                                style="display: none; margin-top: 15px; padding: 15px; background: #e9ecef; border-radius: 4px; border-left: 4px solid #198754;">
                                <div style="font-size: 0.85em; color: #666; margin-bottom: 10px;">
                                    <i class="fa-solid fa-circle-info"></i> Max allowed refund for this item:
                                    <strong>
                                        <fmt:formatNumber value="${req.maxRefundableAmount}" type="currency"
                                            currencySymbol="đ" />
                                    </strong>
                                </div>

                                <label style="font-weight: bold; color: #198754; font-size: 0.9em;">Refund Amount
                                    (VND)</label>
                                <input type="number" name="refundAmount" id="refundAmount" class="form-control"
                                    placeholder="Enter amount to add to customer wallet..." min="0"
                                    max="${req.maxRefundableAmount}">

                                <div style="margin-top: 10px; color: #198754; font-size: 0.85em; font-weight: bold;">
                                    <i class="fa-solid fa-wallet"></i> This amount will be credited directly to the
                                    customer's Website Wallet.
                                </div>
                            </div>

                            <div style="margin-top: 15px;">
                                <label class="info-label" style="font-weight: bold; color: #333;">Admin Note (Required
                                    for Rejections or Actions)</label>
                                <textarea name="adminNote" id="adminNote" class="form-control" rows="4"
                                    placeholder="Explain your decision to the customer...">${req.adminNote != null ? req.adminNote : ''}</textarea>
                            </div>

                            <button type="submit" class="btn btn-submit" style="width: 100%;"><i
                                    class="fa-solid fa-floppy-disk"></i> Save Decision</button>
                        </form>
                    </div>
                </div>

                <script>
                    function toggleDynamicFields() {
                        var status = document.getElementById("statusDropdown").value;
                        var note = document.getElementById("adminNote");
                        var refundSection = document.getElementById("refundSection");
                        var refundAmount = document.getElementById("refundAmount");
                        

                        // 1. Handle the Admin Note Requirement
                        if (status === "2" || status === "4" || status === "6") {
                            note.required = true;
                            note.placeholder = "REQUIRED: Explain your decision to the customer...";
                        } else {
                            note.required = false;
                            note.placeholder = "Optional: Add any internal notes...";
                        }

                        // 2. Handle the Financial Inputs
                        if (status === "5" || status === "7") {
                            // Only show if they select "Completed & Refunded"
                            refundSection.style.display = "block";
                            refundAmount.required = true;
                            bankRef.required = true;
                        } else {
                            refundSection.style.display = "none";
                            refundAmount.required = false;
                            bankRef.required = false;
                            refundAmount.value = ""; // Clear it out if they change their mind
                       
                        }
                    }

                    // Run once on page load to set initial state
                    window.onload = toggleDynamicFields;
                </script>
            </body>

            </html>