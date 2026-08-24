from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, Field
from app.models.interview import InterviewType, InterviewStatus

class InterviewCreateRequest(BaseModel):
    target_role: str = Field(..., example="Backend Developer")
    interview_type: InterviewType = Field(default=InterviewType.FULL_MOCK)
    difficulty: str = Field(default="intermediate")
    resume_skills: List[str] = Field(default=["Python", "FastAPI", "PostgreSQL", "Docker", "REST APIs"])
    resume_projects: List[str] = Field(default=["Async Career Platform built with FastAPI & React"])
    camera_enabled: bool = Field(default=True)

class QuestionRead(BaseModel):
    id: str
    question_order: int
    question_text: str
    question_type: str
    difficulty: str
    source_context: Optional[str] = None

    class Config:
        from_attributes = True

class AnswerSubmitRequest(BaseModel):
    question_id: str
    transcript: str
    duration_seconds: float = Field(default=30.0)

class AnswerFeedbackResponse(BaseModel):
    question_id: str
    evaluated_score: float
    feedback: str
    suggested_improvement: str
    is_followup_needed: bool = False
    followup_question: Optional[str] = None

class InterviewSessionRead(BaseModel):
    id: str
    target_role: str
    interview_type: InterviewType
    difficulty: str
    status: InterviewStatus
    started_at: datetime
    questions: List[QuestionRead] = []

    class Config:
        from_attributes = True

class CommunicationMetricsRead(BaseModel):
    speaking_pace_wpm: float
    filler_word_count: int
    clarity_score: float
    communication_score: float

class VisualMetricsRead(BaseModel):
    camera_enabled: bool
    face_visibility_score: float
    camera_engagement_score: float
    movement_stability_score: float

class InterviewReportResponse(BaseModel):
    interview_id: str
    target_role: str
    overall_score: float
    technical_score: float
    answer_quality_score: float
    communication_score: float
    observed_confidence_indicator: float
    speaking_pace_wpm: float
    filler_word_count: int
    strengths: List[str]
    improvements: List[str]
    recommendations: List[str]
    disclaimer: str
