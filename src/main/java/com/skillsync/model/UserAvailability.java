package com.skillsync.model;

import java.sql.Time;

public class UserAvailability {
    private int availabilityId;
    private int userId;
    private String dayOfWeek;
    private Time startTime;
    private Time endTime;

    public UserAvailability() {}

    public UserAvailability(int userId, String dayOfWeek, Time startTime, Time endTime) {
        this.userId = userId;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    // Getters and Setters
    public int getAvailabilityId() { return availabilityId; }
    public void setAvailabilityId(int availabilityId) { this.availabilityId = availabilityId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(String dayOfWeek) { this.dayOfWeek = dayOfWeek; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }
}