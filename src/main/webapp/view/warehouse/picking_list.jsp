<%@ page contentType="text/html;charset=UTF-8" %>

    <h2>Picking List</h2>

    <p>
        Customer: ${orderInfo.fullname}
    </p>

    <p>
        Address: ${orderInfo.address}
    </p>

    <form method="post">

        <input type="hidden" name="orderId" value="${orderId}">

        <table border="1">

            <tr>
                <th>Book</th>
                <th>Quantity</th>
                <th>Picked</th>
            </tr>

            <c:forEach var="item" items="${pickingItems}">

                <tr>

                    <td>${item.title}</td>

                    <td>${item.quantity}</td>

                    <td>
                        <input type="checkbox">
                    </td>

                </tr>

            </c:forEach>

        </table>

        <br>

        <button type="submit">
            Confirm Picking
        </button>

    </form>