from datetime import datetime
from sqlalchemy import Column, String, Integer, DateTime, Float, Text, ForeignKey, Table
from sqlalchemy.orm import relationship
from app.database.base import Base

class Job(Base):
    __tablename__ = "jobs"

    id = Column(String(36), primary_key=True, index=True)
    external_id = Column(String(100), nullable=True, index=True)
    provider = Column(String(50), nullable=False, default="official")
    title = Column(String(255), nullable=False, index=True)
    company_name = Column(String(255), nullable=False, index=True)
    location = Column(String(255), nullable=False)
    work_type = Column(String(50), nullable=False, default="On-site") # Remote, Hybrid, On-site
    experience_level = Column(String(50), nullable=False, default="Entry Level")
    salary_range = Column(String(100), nullable=True)
    description = Column(Text, nullable=False)
    required_skills_json = Column(Text, nullable=False, default="[]")
    application_url = Column(String(512), nullable=False)
    posted_at = Column(DateTime, default=datetime.utcnow)
    created_at = Column(DateTime, default=datetime.utcnow)

    saved_jobs = relationship("SavedJob", back_populates="job", cascade="all, delete-orphan")
    applications = relationship("JobApplication", back_populates="job", cascade="all, delete-orphan")


class SavedJob(Base):
    __tablename__ = "saved_jobs"

    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    job_id = Column(String(36), ForeignKey("jobs.id", ondelete="CASCADE"), nullable=False, index=True)
    resume_id = Column(String(36), ForeignKey("resumes.id", ondelete="SET NULL"), nullable=True)
    notes = Column(Text, nullable=True)
    saved_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", backref="saved_jobs")
    job = relationship("Job", back_populates="saved_jobs")


class JobApplication(Base):
    __tablename__ = "job_applications"

    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    job_id = Column(String(36), ForeignKey("jobs.id", ondelete="CASCADE"), nullable=False, index=True)
    resume_id = Column(String(36), ForeignKey("resumes.id", ondelete="SET NULL"), nullable=True)
    status = Column(String(50), nullable=False, default="applied") # saved, planning, applied, interview, offer, rejected
    applied_at = Column(DateTime, default=datetime.utcnow)
    notes = Column(Text, nullable=True)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship("User", backref="applications")
    job = relationship("Job", back_populates="applications")


class JobMatch(Base):
    __tablename__ = "job_matches"

    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    job_id = Column(String(36), ForeignKey("jobs.id", ondelete="CASCADE"), nullable=False, index=True)
    resume_id = Column(String(36), ForeignKey("resumes.id", ondelete="CASCADE"), nullable=False, index=True)
    overall_score = Column(Float, nullable=False, default=0.0)
    skill_score = Column(Float, nullable=False, default=0.0)
    experience_score = Column(Float, nullable=False, default=0.0)
    semantic_score = Column(Float, nullable=False, default=0.0)
    explanation_json = Column(Text, nullable=False, default="{}")
    created_at = Column(DateTime, default=datetime.utcnow)
