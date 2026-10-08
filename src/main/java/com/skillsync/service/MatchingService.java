package com.skillsync.service;

import com.skillsync.dao.MatchingDAO;
import com.skillsync.model.MatchResult;

import java.util.*;

public class MatchingService {

    private MatchingDAO matchingDAO = new MatchingDAO();

    // Core 5-Factor Weighted Score Formula
    public double calculateMatchScore(double skillScore, double availabilityScore, 
                                       double goalScore, double interestScore, double reputationScore) {
        return (skillScore * 0.40) +
               (availabilityScore * 0.20) +
               (goalScore * 0.15) +
               (interestScore * 0.15) +
               (reputationScore * 0.10);
    }

    // Skill Score Calculation (Includes Proficiency Check)
    public double calculateSkillScore(Map<String, Integer> learnerSkills, 
                                       Map<String, Integer> teacherSkills, 
                                       List<String> matchedSkillsOut) {
        if (learnerSkills == null || learnerSkills.isEmpty()) return 0.0;

        int validMatches = 0;
        for (Map.Entry<String, Integer> entry : learnerSkills.entrySet()) {
            String skillNeeded = entry.getKey();
            int learnerTargetLevel = entry.getValue();

            if (teacherSkills.containsKey(skillNeeded)) {
                int teacherLevel = teacherSkills.get(skillNeeded);
                // Valid match if teacher level is >= learner's target level
                if (teacherLevel >= learnerTargetLevel) {
                    validMatches++;
                    matchedSkillsOut.add(skillNeeded);
                }
            }
        }

        return ((double) validMatches / learnerSkills.size()) * 100.0;
    }

    public double calculateReputationScore(double rating) {
        return (rating / 5.0) * 100.0;
    }

    // Main Engine Method
    public List<MatchResult> getRankedMatches(int currentUserId) {
        Map<String, Integer> learnerSkills = matchingDAO.getUserLearningSkills(currentUserId);
        List<MatchResult> candidates = matchingDAO.getCandidateUsers(currentUserId);

        for (MatchResult candidate : candidates) {
            Map<String, Integer> teacherSkills = matchingDAO.getCandidateTeachingSkills(candidate.getUserId());

            // 1. Calculate Skill Score
            List<String> matchedSkills = new ArrayList<>();
            double skillScore = calculateSkillScore(learnerSkills, teacherSkills, matchedSkills);
            candidate.setMatchedSkills(matchedSkills);
            candidate.setSkillScore(skillScore);

            // Skill ID ကို တိတိကျကျ Resolve လုပ်သည့် Logic
            if (!matchedSkills.isEmpty()) {
                Map<String, Integer> skillIds = matchingDAO.getCandidateTeachingSkillIds(candidate.getUserId());
                Integer resolvedId = skillIds.get(matchedSkills.get(0)); // ပထမဆုံး Match ဖြစ်သော Skill ၏ ID
                candidate.setSkillId(resolvedId != null ? resolvedId : 0);
            } else {
                candidate.setSkillId(matchingDAO.getFirstSkillId(candidate.getUserId()));
            }

            // 2. Sub-scores & Reputation
            double availabilityScore = 100.0;
            double goalScore = 75.0;
            double interestScore = 70.0;
            
            candidate.setAvailabilityScore(availabilityScore); // NEW
            candidate.setGoalScore(goalScore);                  // NEW
            candidate.setInterestScore(interestScore); 

            double reputationScore = calculateReputationScore(candidate.getRating());
            candidate.setReputationScore(reputationScore);

            // 3. Final Match Score & AI Explanations
            double finalScore = calculateMatchScore(skillScore, availabilityScore, goalScore, interestScore, reputationScore);
            candidate.setMatchScore(Math.round(finalScore * 10.0) / 10.0);

            generateAIExplanations(candidate);
        } // for loop ပိတ်သည်

        // Sort candidates in descending order based on final matchScore
        candidates.sort((a, b) -> Double.compare(b.getMatchScore(), a.getMatchScore()));

        return candidates;
    }

    private void generateAIExplanations(MatchResult match) {
        List<String> explanations = new ArrayList<>();
        if (match.getSkillScore() >= 80) explanations.add("Strong skill compatibility");
        if (match.getAvailabilityScore() >= 80) explanations.add("Compatible schedule");
        if (match.getInterestScore() >= 70) explanations.add("Similar interests");
        if (match.getReputationScore() >= 80) explanations.add("Highly rated mentor");

        match.setExplanations(explanations);
    }
}