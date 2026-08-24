import re
from typing import Dict, Any, List

class TranscriptAnalyzer:
    """
    Analyzes spoken transcripts for communication feedback:
    - Filler word detection (um, uh, like, basically, actually)
    - Speaking pace calculation (WPM)
    - Speech clarity & communication score components
    """

    FILLER_WORDS = ["um", "uh", "like", "basically", "actually", "you know", "i mean", "sort of", "kind of"]

    @classmethod
    def analyze_transcript(cls, full_transcript: str, total_duration_seconds: float) -> Dict[str, Any]:
        words = re.findall(r'\b\w+\b', full_transcript.lower())
        total_words = len(words)
        
        # Count filler words
        filler_count = 0
        detected_fillers: List[str] = []
        for filler in cls.FILLER_WORDS:
            occurrences = len(re.findall(rf'\b{re.escape(filler)}\b', full_transcript.lower()))
            if occurrences > 0:
                filler_count += occurrences
                detected_fillers.append(f"{filler} ({occurrences}x)")

        # Speaking pace (Words Per Minute)
        duration_minutes = max(total_duration_seconds / 60.0, 0.25)
        wpm = total_words / duration_minutes

        # Communication clarity score (100 - filler penalty)
        filler_ratio = (filler_count / max(total_words, 1)) * 100
        clarity_score = max(100.0 - (filler_ratio * 4.0), 55.0)

        # Speaking pace score (Optimal range: 120-160 WPM)
        if 120 <= wpm <= 160:
            pace_score = 95.0
        elif 90 <= wpm < 120 or 160 < wpm <= 190:
            pace_score = 80.0
        else:
            pace_score = 65.0

        overall_communication_score = round((clarity_score * 0.6) + (pace_score * 0.4), 1)

        return {
            "total_words": total_words,
            "speaking_pace_wpm": round(wpm, 1),
            "filler_word_count": filler_count,
            "detected_fillers": detected_fillers,
            "clarity_score": round(clarity_score, 1),
            "communication_score": overall_communication_score,
        }
