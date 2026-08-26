from datetime import datetime
from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field

class JobRead(BaseModel):
    id: str
    external_id: Optional[str] = None
    provider: str
    title: str
    company_name: str
    location: str
    work_type: str
    experience_level: str
    salary_range: Optional[str] = None
    description: str
    required_skills: List[str] = []
    application_url: str
    posted_at: datetime

    model_config = {"from_attributes": True}

class JobMatchRead(BaseModel):
    job_id: str
    resume_id: str
    overall_match: float
    skill_match_score: float
    experience_match_score: float
    semantic_match_score: float
    strong_matches: List[str] = []
    partial_matches: List[str] = []
    missing_skills: List[str] = []
    evidence_trace: List[Dict[str, str]] = []

class JobApplicationCreate(BaseModel):
    job_id: str
    resume_id: Optional[str] = None
    status: str = "applied" # saved, planning, applied, interview, offer, rejected
    notes: Optional[str] = None

class JobApplicationUpdate(BaseModel):
    status: str
    notes: Optional[str] = None

class JobApplicationRead(BaseModel):
    id: str
    job_id: str
    job_title: str
    company_name: str
    status: str
    applied_at: datetime
    notes: Optional[str] = None

    model_config = {"from_attributes": True}
