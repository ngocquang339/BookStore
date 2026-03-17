package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import org.junit.Test;

import com.group2.bookstore.model.Category;
import java.util.Scanner;
public class CategoriesTest {
    @Test
    public void kiemTraCategories(){
        CategoryDAO dao = new CategoryDAO();
        List<Category> list = dao.getCategories();
        for (Category c : list) {
            System.out.println(c.getId() + " - " + c.getName());
        }
    }
}
