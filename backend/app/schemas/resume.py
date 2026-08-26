from datetime import datetime
from typing import List, Optional, Dict, Any
from pydantic import BaseModel

class ResumeRead(BaseModel):
    id: str
    file_name: str
    file_size: int
    uploaded_at: datetime
    is_active: bool
    parsed_skills: List[str] = []
    parsed_projects: List[str] = []
    ats_score: float = 0.0
    ats_details: Dict[str, Any] = {}

    model_config = {"from_attributes": True}

class ResumeRenameRequest(BaseModel):
    file_name: str
