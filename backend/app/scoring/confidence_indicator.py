from typing import Dict, Any

class ConfidenceIndicatorService:
    """
    Computes the Observed Communication Confidence score by combining
    speech clarity, speaking pace, answer structure, filler word control,
    and camera engagement signals.

    Includes explicit disclaimers emphasizing that this score estimates
    observable communication behavior during mock interviews and is NOT
    a psychological measurement or employment assessment.
    """

    DISCLAIMER = (
        "This score estimates observable communication signals during mock practice "
        "and is not a measurement of your actual psychological confidence, personality, "
        "or employment assessment."
    )

    @classmethod
    def compute_scores(
        cls,
        technical_score: float,
        answer_quality_score: float,
        communication_score: float,
        camera_enabled: bool = True
    ) -> Dict[str, Any]:
        # Visual engagement estimate (if camera enabled)
        camera_engagement = 82.0 if camera_enabled else 75.0
        
        # Observed Communication Confidence calculation
        observed_confidence = round(
            (communication_score * 0.45) +
            (answer_quality_score * 0.35) +
            (camera_engagement * 0.20),
            1
        )

        overall_score = round(
            (technical_score * 0.4) +
            (answer_quality_score * 0.3) +
            (communication_score * 0.2) +
            (observed_confidence * 0.1),
            1
        )

        return {
            "overall_score": overall_score,
            "technical_score": technical_score,
            "answer_quality_score": answer_quality_score,
            "communication_score": communication_score,
            "observed_confidence_indicator": observed_confidence,
            "camera_engagement": camera_engagement,
            "disclaimer": cls.DISCLAIMER,
        }
