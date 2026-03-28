package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import org.mockito.Mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import org.mockito.MockitoAnnotations;

import com.group2.bookstore.model.Book;

public class BookDAOTest {

    @Mock
    private Connection mockConn;
    @Mock
    private PreparedStatement mockPs;
    @Mock
    private ResultSet mockRs;

    private BookDAO dao;
    private Book dummyBook;

    @BeforeEach
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);

        // 1. Setup the DAO with our Mock Connection
        dao = new BookDAO() {
            @Override
            public Connection getConnection() { 
                return mockConn;
            }
        };

        // 2. Setup a dummy book we can reuse in all tests
        dummyBook = new Book();
        dummyBook.setTitle("Test Title");
        dummyBook.setAuthor("Test Author");
        dummyBook.setPrice(150000.0);
        dummyBook.setDescription("A great book");
        dummyBook.setImageUrl("test.jpg");
        dummyBook.setStockQuantity(10);
        dummyBook.setCategoryId(1);
        dummyBook.setActive(true);
        dummyBook.setPublisher("Test Publisher");
        dummyBook.setSupplier("Test Supplier");
        dummyBook.setYearOfPublish(2023);
        dummyBook.setNumberPage(300);
    }

    // --- SCENARIO 1: 100% Success ---
    @Test
    public void testInsertBook_Success() throws Exception {
        // Train Mocks
        when(mockConn.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS))).thenReturn(mockPs);
        when(mockPs.executeUpdate()).thenReturn(1); 
        when(mockPs.getGeneratedKeys()).thenReturn(mockRs);
        when(mockRs.next()).thenReturn(true); // There is a generated key
        when(mockRs.getInt(1)).thenReturn(99); // The new ID is 99

        // Execute
        int generatedId = dao.insertBook(dummyBook);

        // Assert
        assertEquals(99, generatedId, "Should return the auto-generated ID 99");

        // Verify all 12 parameters were set exactly as expected
        verify(mockPs).setString(1, "Test Title");
        verify(mockPs).setString(2, "Test Author");
        verify(mockPs).setDouble(3, 150000.0);
        verify(mockPs).setString(4, "A great book");
        verify(mockPs).setString(5, "test.jpg");
        verify(mockPs).setInt(6, 10);
        verify(mockPs).setInt(7, 1);
        verify(mockPs).setBoolean(8, true);
        verify(mockPs).setString(9, "Test Publisher");
        verify(mockPs).setString(10, "Test Supplier");
        verify(mockPs).setInt(11, 2023);
        verify(mockPs).setInt(12, 300);
        
        verify(mockPs).executeUpdate(); // Verify the execution actually happened
    }

    // --- SCENARIO 2: Insert succeeds, but no ID is returned ---
    @Test
    public void testInsertBook_NoGeneratedKey() throws Exception {
        // Train Mocks
        when(mockConn.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS))).thenReturn(mockPs);
        when(mockPs.executeUpdate()).thenReturn(1);
        when(mockPs.getGeneratedKeys()).thenReturn(mockRs);
        
        // This time, simulate that the ResultSet is empty (SQL Server didn't return an ID)
        when(mockRs.next()).thenReturn(false); 

        // Execute
        int generatedId = dao.insertBook(dummyBook);

        // Assert
        assertEquals(0, generatedId, "Should return default 0 if no key was generated");
    }

    // --- SCENARIO 3: Database Error (Exception thrown) ---
    @Test
    public void testInsertBook_ThrowsException() throws Exception {
        // Train Mocks
        // Force the connection to throw an error when trying to prepare the statement
        when(mockConn.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS)))
            .thenThrow(new SQLException("Database connection failed!"));

        // Execute (If your catch block works, this won't crash the test)
        int generatedId = dao.insertBook(dummyBook);

        // Assert
        assertEquals(0, generatedId, "Should return 0 when an exception is caught");
        
        // Verify that it never reached the executeUpdate step because it crashed early
        verify(mockPs, never()).executeUpdate(); 
    }

    // --- SCENARIO: UTCID03 - Book Object is null ---
    @Test
    public void testInsertBook_NullBook() throws Exception {
        // Since there is no b.getTitle() null check in your DAO, passing null
        // will cause a NullPointerException in the try block, which is caught by catch(Exception e), returning 0.
        int generatedId = dao.insertBook(null);
        assertEquals(0, generatedId, "UTCID03: Should return 0 if the Book object is null");
    }

    // --- SCENARIO: UTCID04 - Title is null or Empty ---
    @Test
    public void testInsertBook_NullOrEmptyTitle() throws Exception {
        dummyBook.setTitle(""); // Set empty title
        
        when(mockConn.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS))).thenReturn(mockPs);
        // Simulate SQL Server rejecting the empty/null string (e.g., NOT NULL constraint)
        when(mockPs.executeUpdate()).thenThrow(new SQLException("Cannot insert the value NULL into column 'title'"));

        int generatedId = dao.insertBook(dummyBook);
        assertEquals(0, generatedId, "UTCID04: Should return 0 when SQL rejects empty/null title");
    }

    // --- SCENARIO: UTCID05 - Title exceeds max DB length ---
    @Test
    public void testInsertBook_TitleExceedsLength() throws Exception {
        dummyBook.setTitle("A".repeat(300)); // Title too long for VARCHAR(255)
        
        when(mockConn.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS))).thenReturn(mockPs);
        // Simulate SQL Server Data Truncation error
        when(mockPs.executeUpdate()).thenThrow(new SQLException("String or binary data would be truncated."));

        int generatedId = dao.insertBook(dummyBook);
        assertEquals(0, generatedId, "UTCID05: Should return 0 when SQL rejects long title");
    }

    // --- SCENARIO: UTCID07 - Price is Negative ---
    @Test
    public void testInsertBook_NegativePrice() throws Exception {
        dummyBook.setPrice(-50000.0);
        
        when(mockConn.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS))).thenReturn(mockPs);
        // Simulate SQL Server CHECK constraint violation (price >= 0)
        when(mockPs.executeUpdate()).thenThrow(new SQLException("The INSERT statement conflicted with the CHECK constraint"));

        int generatedId = dao.insertBook(dummyBook);
        assertEquals(0, generatedId, "UTCID07: Should return 0 when SQL rejects negative price");
    }

    // --- SCENARIO: UTCID08 & UTCID09 - Stock Quantity is 0 or Negative ---
    @Test
    public void testInsertBook_InvalidStockQuantity() throws Exception {
        dummyBook.setStockQuantity(-5); // UTCID09 (Negative) or 0 (UTCID08)
        
        when(mockConn.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS))).thenReturn(mockPs);
        // Simulate SQL Server CHECK constraint violation
        when(mockPs.executeUpdate()).thenThrow(new SQLException("The INSERT statement conflicted with the CHECK constraint"));

        int generatedId = dao.insertBook(dummyBook);
        assertEquals(0, generatedId, "UTCID08/09: Should return 0 when SQL rejects invalid stock quantity");
    }

    // --- SCENARIO: UTCID10 - Number of Pages is 0 or Negative ---
    @Test
    public void testInsertBook_InvalidNumberPage() throws Exception {
        dummyBook.setNumberPage(0); // Boundary value 0
        
        when(mockConn.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS))).thenReturn(mockPs);
        // Simulate SQL Server CHECK constraint violation
        when(mockPs.executeUpdate()).thenThrow(new SQLException("The INSERT statement conflicted with the CHECK constraint"));

        int generatedId = dao.insertBook(dummyBook);
        assertEquals(0, generatedId, "UTCID10: Should return 0 when SQL rejects invalid page number");
    }
}