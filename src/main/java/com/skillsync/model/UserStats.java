package com.skillsync.model;

public class UserStats {
    private int reputationScore;
    private int sessionsCompleted;
    private double averageRating;
    private int streakDays;

    public UserStats() {}

    public UserStats(int reputationScore, int sessionsCompleted, double averageRating, int streakDays) {
        this.reputationScore = reputationScore;
        this.sessionsCompleted = sessionsCompleted;
        this.averageRating = averageRating;
        this.streakDays = streakDays;
    }

    public int getReputationScore() { return reputationScore; }
    public void setReputationScore(int reputationScore) { this.reputationScore = reputationScore; }

    public int getSessionsCompleted() { return sessionsCompleted; }
    public void setSessionsCompleted(int sessionsCompleted) { this.sessionsCompleted = sessionsCompleted; }

    public double getAverageRating() { return averageRating; }
    public void setAverageRating(double averageRating) { this.averageRating = averageRating; }

    public int getStreakDays() { return streakDays; }
    public void setStreakDays(int streakDays) { this.streakDays = streakDays; }
}