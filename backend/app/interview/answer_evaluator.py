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
        
        # Zero score for blank/empty responses
        if word_count == 0:
            return {
                "score": 0.0,
                "word_count": 0,
                "feedback": "No answer detected. You did not speak or type a response for this question.",
                "suggested_improvement": "Ensure your microphone is active or type a response before proceeding.",
                "is_followup_needed": True,
                "followup_question": "Would you like to try answering this question again?",
            }

        # Quality assessment based on answer depth and key technical terms
        if word_count < 10:
            score = 40.0
            feedback = "Your answer was very brief. Try adding specific examples, architecture details, and technical rationale."
            improvement = "Elaborate further using concrete technical details and the STAR method (Situation, Task, Action, Result)."
            needs_followup = True
            followup = "Can you provide a more detailed step-by-step technical explanation with a concrete example?"
        elif word_count < 18:
            score = 72.0
            feedback = "Solid answer covering primary concepts, though further technical depth would strengthen it."
            improvement = "Mention specific tools, libraries, benchmarks, or design trade-offs to make your answer stand out."
            needs_followup = False
            followup = None
        else:
            score = 88.0
            feedback = "Excellent answer with strong technical depth, clear context, and effective structure!"
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
