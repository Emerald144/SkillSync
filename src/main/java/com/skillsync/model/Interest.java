package com.skillsync.model;

public class Interest {
    private int interestId;
    private String interestName;

    public Interest() {}

    public Interest(int interestId, String interestName) {
        this.interestId = interestId;
        this.interestName = interestName;
    }

    public int getInterestId() { return interestId; }
    public void setInterestId(int interestId) { this.interestId = interestId; }

    public String getInterestName() { return interestName; }
    public void setInterestName(String interestName) { this.interestName = interestName; }
}