package com.skillsync.model;

import java.sql.Timestamp;

public class Session {
    private int sessionId;
    private int requestId;
    private int teacherId;
    private int learnerId;
    private String sessionType; // 'Online' or 'In-Person'
    private String location;
    private String meetingLink;
    private Timestamp sessionDate;
    private String status; // 'Scheduled','In Progress','Completed','Cancelled'
    private String notes;

    // Joined fields for display
    private String otherUserName;
    private String otherUserPhoto;
    private String skillName;
    private boolean isTeacher; // true if currentUser is the teacher in this session
    
    private boolean learnerConfirmed;
    private boolean teacherConfirmed;
    private Timestamp learnerConfirmedAt;
    private Timestamp teacherConfirmedAt;

    public Session() {}

    public int getSessionId() { return sessionId; }
    public void setSessionId(int sessionId) { this.sessionId = sessionId; }

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getTeacherId() { return teacherId; }
    public void setTeacherId(int teacherId) { this.teacherId = teacherId; }

    public int getLearnerId() { return learnerId; }
    public void setLearnerId(int learnerId) { this.learnerId = learnerId; }

    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getMeetingLink() { return meetingLink; }
    public void setMeetingLink(String meetingLink) { this.meetingLink = meetingLink; }

    public Timestamp getSessionDate() { return sessionDate; }
    public void setSessionDate(Timestamp sessionDate) { this.sessionDate = sessionDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getOtherUserName() { return otherUserName; }
    public void setOtherUserName(String otherUserName) { this.otherUserName = otherUserName; }

    public String getOtherUserPhoto() { return otherUserPhoto; }
    public void setOtherUserPhoto(String otherUserPhoto) { this.otherUserPhoto = otherUserPhoto; }

    public String getSkillName() { return skillName; }
    public void setSkillName(String skillName) { this.skillName = skillName; }

    public boolean isTeacher() { return isTeacher; }
    public void setTeacher(boolean teacher) { isTeacher = teacher; }

    public String getInitials() {
        if (otherUserName == null || otherUserName.trim().isEmpty()) return "U";
        String[] parts = otherUserName.trim().split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < Math.min(2, parts.length); i++) {
            if (!parts[i].isEmpty()) sb.append(Character.toUpperCase(parts[i].charAt(0)));
        }
        return sb.length() > 0 ? sb.toString() : "U";
    }
    
 // Required by EL to access ${session.notes}
    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public boolean isLearnerConfirmed() { return learnerConfirmed; }
    public void setLearnerConfirmed(boolean learnerConfirmed) { this.learnerConfirmed = learnerConfirmed; }

    public boolean isTeacherConfirmed() { return teacherConfirmed; }
    public void setTeacherConfirmed(boolean teacherConfirmed) { this.teacherConfirmed = teacherConfirmed; }

    public Timestamp getLearnerConfirmedAt() { return learnerConfirmedAt; }
    public void setLearnerConfirmedAt(Timestamp learnerConfirmedAt) { this.learnerConfirmedAt = learnerConfirmedAt; }

    public Timestamp getTeacherConfirmedAt() { return teacherConfirmedAt; }
    public void setTeacherConfirmedAt(Timestamp teacherConfirmedAt) { this.teacherConfirmedAt = teacherConfirmedAt; }
}