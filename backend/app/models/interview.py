import uuid
from datetime import datetime
from enum import Enum as PyEnum
from typing import Optional, List
from sqlalchemy import String, DateTime, ForeignKey, Integer, Float, Text, Boolean, Enum
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database.base import Base

class InterviewType(str, PyEnum):
    QUICK_PRACTICE = "quick_practice"
    TECHNICAL = "technical"
    BEHAVIORAL = "behavioral"
    RESUME_BASED = "resume_based"
    FULL_MOCK = "full_mock"

class InterviewStatus(str, PyEnum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

class InterviewSession(Base):
    __tablename__ = "interview_sessions"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id: Mapped[str] = mapped_column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    resume_id: Mapped[Optional[str]] = mapped_column(String(36), nullable=True)
    target_role: Mapped[str] = mapped_column(String(150), nullable=False)
    interview_type: Mapped[InterviewType] = mapped_column(Enum(InterviewType), default=InterviewType.FULL_MOCK, nullable=False)
    difficulty: Mapped[str] = mapped_column(String(50), default="intermediate", nullable=False)
    status: Mapped[InterviewStatus] = mapped_column(Enum(InterviewStatus), default=InterviewStatus.PENDING, nullable=False)
    started_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    completed_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)

    # Relationships
    questions: Mapped[List["InterviewQuestion"]] = relationship("InterviewQuestion", back_populates="session", cascade="all, delete-orphan")
    report: Mapped[Optional["InterviewReport"]] = relationship("InterviewReport", back_populates="session", uselist=False, cascade="all, delete-orphan")
    communication_metrics: Mapped[Optional["CommunicationMetrics"]] = relationship("CommunicationMetrics", back_populates="session", uselist=False, cascade="all, delete-orphan")
    visual_metrics: Mapped[Optional["VisualMetrics"]] = relationship("VisualMetrics", back_populates="session", uselist=False, cascade="all, delete-orphan")

class InterviewQuestion(Base):
    __tablename__ = "interview_questions"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    interview_id: Mapped[str] = mapped_column(String(36), ForeignKey("interview_sessions.id", ondelete="CASCADE"), nullable=False)
    question_order: Mapped[int] = mapped_column(Integer, nullable=False, default=1)
    question_text: Mapped[str] = mapped_column(Text, nullable=False)
    question_type: Mapped[str] = mapped_column(String(50), nullable=False, default="technical")
    difficulty: Mapped[str] = mapped_column(String(50), default="intermediate", nullable=False)
    source_context: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    session: Mapped["InterviewSession"] = relationship("InterviewSession", back_populates="questions")
    answer: Mapped[Optional["InterviewAnswer"]] = relationship("InterviewAnswer", back_populates="question", uselist=False, cascade="all, delete-orphan")

class InterviewAnswer(Base):
    __tablename__ = "interview_answers"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    question_id: Mapped[str] = mapped_column(String(36), ForeignKey("interview_questions.id", ondelete="CASCADE"), nullable=False)
    transcript: Mapped[str] = mapped_column(Text, nullable=False)
    duration_seconds: Mapped[float] = mapped_column(Float, default=0.0, nullable=False)
    word_count: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)

    question: Mapped["InterviewQuestion"] = relationship("InterviewQuestion", back_populates="answer")

class CommunicationMetrics(Base):
    __tablename__ = "communication_metrics"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    interview_id: Mapped[str] = mapped_column(String(36), ForeignKey("interview_sessions.id", ondelete="CASCADE"), nullable=False)
    speaking_pace_wpm: Mapped[float] = mapped_column(Float, default=130.0, nullable=False)
    filler_word_count: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    clarity_score: Mapped[float] = mapped_column(Float, default=80.0, nullable=False)
    communication_score: Mapped[float] = mapped_column(Float, default=80.0, nullable=False)

    session: Mapped["InterviewSession"] = relationship("InterviewSession", back_populates="communication_metrics")

class VisualMetrics(Base):
    __tablename__ = "visual_metrics"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    interview_id: Mapped[str] = mapped_column(String(36), ForeignKey("interview_sessions.id", ondelete="CASCADE"), nullable=False)
    camera_enabled: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    face_visibility_score: Mapped[float] = mapped_column(Float, default=85.0, nullable=False)
    camera_engagement_score: Mapped[float] = mapped_column(Float, default=80.0, nullable=False)
    movement_stability_score: Mapped[float] = mapped_column(Float, default=88.0, nullable=False)

    session: Mapped["InterviewSession"] = relationship("InterviewSession", back_populates="visual_metrics")

class InterviewReport(Base):
    __tablename__ = "interview_reports"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    interview_id: Mapped[str] = mapped_column(String(36), ForeignKey("interview_sessions.id", ondelete="CASCADE"), nullable=False)
    overall_score: Mapped[float] = mapped_column(Float, nullable=False, default=80.0)
    technical_score: Mapped[float] = mapped_column(Float, nullable=False, default=80.0)
    answer_quality_score: Mapped[float] = mapped_column(Float, nullable=False, default=80.0)
    communication_score: Mapped[float] = mapped_column(Float, nullable=False, default=80.0)
    observed_confidence_indicator: Mapped[float] = mapped_column(Float, nullable=False, default=78.0)
    strengths_json: Mapped[str] = mapped_column(Text, nullable=False, default="[]")
    improvements_json: Mapped[str] = mapped_column(Text, nullable=False, default="[]")
    recommendations_json: Mapped[str] = mapped_column(Text, nullable=False, default="[]")
    disclaimer: Mapped[str] = mapped_column(Text, nullable=False, default="This score estimates observable communication signals and is not a measurement of your actual psychological confidence or employment assessment.")

    session: Mapped["InterviewSession"] = relationship("InterviewSession", back_populates="report")
