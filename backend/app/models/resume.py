from datetime import datetime
from sqlalchemy import Column, String, Integer, DateTime, Boolean, Text, ForeignKey
from sqlalchemy.orm import relationship
from app.database.base import Base

class Resume(Base):
    __tablename__ = "resumes"

    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    file_name = Column(String(255), nullable=False)
    file_path = Column(String(512), nullable=False)
    file_size = Column(Integer, nullable=False, default=0)
    uploaded_at = Column(DateTime, default=datetime.utcnow)
    is_active = Column(Boolean, default=False)
    parsed_skills_json = Column(Text, nullable=True, default="[]")
    parsed_projects_json = Column(Text, nullable=True, default="[]")
    ats_score_json = Column(Text, nullable=True, default="{}")

    user = relationship("User", back_populates="resumes")
