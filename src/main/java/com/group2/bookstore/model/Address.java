package com.group2.bookstore.model;

public class Address {
    private int id;
    private int userId;
    private String fullName;
    private String phone;
    private String country;
    private String city;
    private String district;
    private String ward;
    private String addressDetail;
    private String zipCode;
    private boolean isDefaultBilling;
    private boolean isDefaultShipping;

    // Constructor rỗng
    public Address() {
    }

    // Constructor đầy đủ
    public Address(int id, int userId, String fullName, String phone, 
                   String country, String city, String district, String ward, 
                   String addressDetail, String zipCode, boolean isDefaultBilling, boolean isDefaultShipping) {
        this.id = id;
        this.userId = userId;
        this.fullName = fullName;
        this.phone = phone;
        this.country = country;
        this.city = city;
        this.district = district;
        this.ward = ward;
        this.addressDetail = addressDetail;
        this.zipCode = zipCode;
        this.isDefaultBilling = isDefaultBilling;
        this.isDefaultShipping = isDefaultShipping;
    }

    // Bạn dùng IDE (Alt + Insert hoặc Source -> Generate Getters and Setters) 
    // để tạo tự động các hàm get/set cho tất cả các biến ở trên nhé cho code bớt dài!
    
    public int getId() { return id; }

    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }

    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }

    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }

    public void setPhone(String phone) { this.phone = phone; }

    public String getCountry() { return country; }

    public void setCountry(String country) { this.country = country; }

    public String getCity() { return city; }

    public void setCity(String city) { this.city = city; }

    public String getDistrict() { return district; }

    public void setDistrict(String district) { this.district = district; }

    public String getWard() { return ward; }

    public void setWard(String ward) { this.ward = ward; }

    public String getAddressDetail() { return addressDetail; }

    public void setAddressDetail(String addressDetail) { this.addressDetail = addressDetail; }

    public String getZipCode() { return zipCode; }

    public void setZipCode(String zipCode) { this.zipCode = zipCode; }

    public boolean isDefaultBilling() { return isDefaultBilling; }

    public void setDefaultBilling(boolean defaultBilling) { isDefaultBilling = defaultBilling; }

    public boolean isDefaultShipping() { return isDefaultShipping; }
    
    public void setDefaultShipping(boolean defaultShipping) { isDefaultShipping = defaultShipping; }
}