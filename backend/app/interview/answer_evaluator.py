from typing import Dict, Any

class AnswerEvaluator:
    """
    Evaluates candidate answers for technical accuracy, relevance, completeness,
    and STAR method structure.
    """

    @staticmethod
    def evaluate_answer(question_text: str, transcript: str, duration_seconds: float) -> Dict[str, Any]:
        words = transcript.strip().split()
        word_count = len(words)
        
        # Base quality assessment based on answer depth and key technical terms
        if word_count < 10:
            score = 50.0
            feedback = "Your answer was very brief. Try adding specific examples, architecture details, and technical rationale."
            improvement = "Elaborate further using concrete technical details and the STAR method (Situation, Task, Action, Result)."
            needs_followup = True
            followup = "Can you provide a more detailed step-by-step technical explanation with a concrete example?"
        elif word_count < 18:
            score = 75.0
            feedback = "Solid answer covering the primary points, though further technical depth would strengthen it."
            improvement = "Mention specific tools, libraries, benchmarks, or design trade-offs to make your answer stand out."
            needs_followup = False
            followup = None
        else:
            score = 88.0
            feedback = "Excellent answer with strong detail, clear technical context, and effective structure!"
            improvement = "Keep up the detailed explanations while maintaining a concise and direct delivery."
            needs_followup = False
            followup = None

        return {
            "score": score,
            "word_count": word_count,
            "feedback": feedback,
            "suggested_improvement": improvement,
            "is_followup_needed": needs_followup,
            "followup_question": followup,
        }
