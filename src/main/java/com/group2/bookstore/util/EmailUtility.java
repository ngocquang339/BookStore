package com.group2.bookstore.util;

import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtility {

    public static void sendEmail(String toEmail, String otpCode) {
        // 1. Cấu hình thông tin Server của Google
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); // SMTP Host
        props.put("mail.smtp.port", "587"); // TLS Port
        props.put("mail.smtp.auth", "true"); // Enable Auth
        props.put("mail.smtp.starttls.enable", "true"); // Enable TLS

        // 2. Tài khoản Gmail của bạn (Người gửi)
        final String fromEmail = "quangakashi@gmail.com"; 
        final String password = "gkjy pimg ynqr ogur"; // KHÔNG PHẢI PASS ĐĂNG NHẬP

        // 3. Tạo phiên làm việc (Session)
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            // 4. Tạo nội dung Email
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Mã xác thực đăng ký BookStore");
            msg.setText("Chào bạn,\n\nMã xác thực (OTP) của bạn là: " + otpCode + "\n\nMã này sẽ hết hạn trong 5 phút.");

            // 5. Gửi đi
            Transport.send(msg);
            System.out.println("Gửi mail thành công!");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    // Hàm sinh mã OTP ngẫu nhiên 6 số
    public static String getRandomOTP() {
        Random rnd = new Random();
        int number = rnd.nextInt(999999);
        return String.format("%06d", number);
    }
}