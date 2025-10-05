package com.attendance.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Utility class for managing database connections
 * Day 1 - Basic structure
 */
public class DBUtil {
    
    // Database connection parameters
    private static final String DB_URL = "jdbc:mysql://localhost:3306/attendance_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";
    
    // JDBC driver class
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    /**
     * Get a database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            // Load the MySQL JDBC driver
            Class.forName(JDBC_DRIVER);
            
            // Establish the connection
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Database connection established successfully");
            
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found");
            e.printStackTrace();
            throw new SQLException("Driver not found", e);
        } catch (SQLException e) {
            System.err.println("Connection failed");
            e.printStackTrace();
            throw e;
        }
        
        return connection;
    }
    
    /**
     * Close the database connection
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed successfully");
            } catch (SQLException e) {
                System.err.println("Error closing connection");
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Test the database connection
     * @param args command line arguments
     */
    public static void main(String[] args) {
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn != null) {
                System.out.println("Test connection successful!");
            }
        } catch (SQLException e) {
            System.err.println("Test connection failed!");
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
    }
}
