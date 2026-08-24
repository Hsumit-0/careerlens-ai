from typing import Dict, Any, List

class FeedbackGenerator:
    """
    Generates actionable, constructive feedback report with strengths,
    improvement areas, and daily recommended practice tasks.
    """

    @staticmethod
    def generate_report_feedback(
        target_role: str,
        technical_score: float,
        communication_score: float,
        filler_count: int,
        speaking_pace_wpm: float,
    ) -> Dict[str, List[str]]:
        strengths = [
            f"Demonstrated clear technical vocabulary relevant to {target_role} roles.",
            "Responded to questions with relevant architectural examples.",
            "Maintained consistent engagement and steady response flow."
        ]

        improvements = []
        if filler_count > 3:
            improvements.append(f"Detected {filler_count} filler words during responses. Practice pausing silently instead of using vocal fillers.")
        else:
            strengths.append("Excellent control over vocal filler words!")

        if speaking_pace_wpm > 160:
            improvements.append(f"Speaking pace was fast ({speaking_pace_wpm:.0f} WPM). Slow down slightly to emphasize key points.")
        elif speaking_pace_wpm < 110:
            improvements.append(f"Speaking pace was deliberate ({speaking_pace_wpm:.0f} WPM). Maintain slightly more momentum.")

        improvements.append("Use the STAR method (Situation, Task, Action, Result) for behavioral questions.")

        recommendations = [
            "Practice a 60-second self-introduction highlighting your top project.",
            f"Review key {target_role} architecture patterns and database scaling.",
            "Record a 5-minute mock interview session using camera preview to practice gaze engagement.",
            "Answer 3 targeted technical questions without using filler words."
        ]

        return {
            "strengths": strengths,
            "improvements": improvements,
            "recommendations": recommendations,
        }
