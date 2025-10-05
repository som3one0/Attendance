package com.attendance.model;

import java.io.Serializable;

public class AttendanceRecord implements Serializable {
    private int userId;
    private String username;
    private String department;
    private String date; // use String for easy JSP display
    private String status;

    public AttendanceRecord() {}

    public AttendanceRecord(int userId, String username, String department, String date, String status) {
        this.userId = userId;
        this.username = username;
        this.department = department;
        this.date = date;
        this.status = status;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
