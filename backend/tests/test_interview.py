import pytest
from app.interview.question_generator import QuestionGenerator
from app.interview.answer_evaluator import AnswerEvaluator
from app.speech.transcript_analyzer import TranscriptAnalyzer
from app.scoring.confidence_indicator import ConfidenceIndicatorService
from app.models.interview import InterviewType

def test_question_generator_resume_based():
    questions = QuestionGenerator.generate_questions(
        target_role="Backend Developer",
        interview_type=InterviewType.FULL_MOCK,
        difficulty="intermediate",
        skills=["Python", "FastAPI", "PostgreSQL"],
        projects=["Async Career Platform"]
    )
    assert len(questions) >= 3
    # Check that questions reference the specific resume project
    assert any("Async Career Platform" in q["question_text"] for q in questions)
    assert any("FastAPI" in q["question_text"] for q in questions)

def test_answer_evaluator():
    eval_short = AnswerEvaluator.evaluate_answer(
        question_text="Explain FastAPI architecture",
        transcript="I used FastAPI",
        duration_seconds=5.0
    )
    assert eval_short["score"] < 70.0
    assert eval_short["is_followup_needed"] is True

    eval_detailed = AnswerEvaluator.evaluate_answer(
        question_text="Explain FastAPI architecture",
        transcript="I designed an asynchronous microservice using FastAPI, Pydantic v2 validation models, and SQLAlchemy 2.x async engine with connection pooling.",
        duration_seconds=30.0
    )
    assert eval_detailed["score"] >= 80.0
    assert eval_detailed["is_followup_needed"] is False

def test_transcript_analyzer_fillers():
    transcript = "Um basically I built this FastAPI endpoint uh like using Python and PostgreSQL."
    analysis = TranscriptAnalyzer.analyze_transcript(transcript, 15.0)
    assert analysis["filler_word_count"] >= 3
    assert "um (1x)" in analysis["detected_fillers"]
    assert analysis["clarity_score"] < 100.0

def test_confidence_indicator_disclaimer():
    scores = ConfidenceIndicatorService.compute_scores(
        technical_score=85.0,
        answer_quality_score=80.0,
        communication_score=78.0,
        camera_enabled=True
    )
    assert "observed_confidence_indicator" in scores
    assert scores["overall_score"] > 70.0
    assert "estimates observable communication signals" in scores["disclaimer"]
