import json
import uuid
from datetime import datetime
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, delete

from app.database.session import get_db
from app.models.user import User
from app.models.resume import Resume
from app.models.job import Job, SavedJob, JobApplication, JobMatch
from app.schemas.job import (
    JobRead, JobMatchRead, JobApplicationCreate,
    JobApplicationUpdate, JobApplicationRead
)
from app.core.dependencies import get_current_active_user
from app.jobs.providers.base import ProviderRegistry

router = APIRouter()

@router.get("/search", response_model=List[JobRead])
async def search_jobs(
    query: Optional[str] = Query(None),
    location: Optional[str] = Query(None),
    remote_only: bool = Query(False),
    experience_level: Optional[str] = Query(None),
    job_type: Optional[str] = Query(None),
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=50),
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    raw_jobs = ProviderRegistry.get_all_jobs(
        query=query,
        location=location,
        remote_only=remote_only,
        experience_level=experience_level,
        job_type=job_type,
        page=page,
        limit=limit
    )

    jobs: List[JobRead] = []
    for j in raw_jobs:
        posted_at = datetime.fromisoformat(j["posted_at"].replace("Z", "+00:00")) if "posted_at" in j else datetime.utcnow()
        jobs.append(JobRead(
            id=j["id"],
            external_id=j.get("external_id"),
            provider=j.get("provider", "official"),
            title=j["title"],
            company_name=j["company_name"],
            location=j["location"],
            work_type=j["work_type"],
            experience_level=j["experience_level"],
            salary_range=j.get("salary_range"),
            description=j["description"],
            required_skills=j.get("required_skills", []),
            application_url=j["application_url"],
            posted_at=posted_at
        ))

    return jobs


@router.get("/recommendations", response_model=List[JobRead])
async def get_recommended_jobs(
    resume_id: Optional[str] = Query(None),
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    raw_jobs = ProviderRegistry.get_all_jobs(limit=6)
    result: List[JobRead] = []

    for j in raw_jobs:
        posted_at = datetime.fromisoformat(j["posted_at"].replace("Z", "+00:00")) if "posted_at" in j else datetime.utcnow()
        result.append(JobRead(
            id=j["id"],
            external_id=j.get("external_id"),
            provider=j.get("provider", "official"),
            title=j["title"],
            company_name=j["company_name"],
            location=j["location"],
            work_type=j["work_type"],
            experience_level=j["experience_level"],
            salary_range=j.get("salary_range"),
            description=j["description"],
            required_skills=j.get("required_skills", []),
            application_url=j["application_url"],
            posted_at=posted_at
        ))

    return result


@router.get("/{job_id}", response_model=JobRead)
async def get_job_details(
    job_id: str,
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    j = ProviderRegistry.get_job_by_id(job_id)
    if not j:
        raise HTTPException(status_code=404, detail="Job posting not found")

    posted_at = datetime.fromisoformat(j["posted_at"].replace("Z", "+00:00")) if "posted_at" in j else datetime.utcnow()
    return JobRead(
        id=j["id"],
        external_id=j.get("external_id"),
        provider=j.get("provider", "official"),
        title=j["title"],
        company_name=j["company_name"],
        location=j["location"],
        work_type=j["work_type"],
        experience_level=j["experience_level"],
        salary_range=j.get("salary_range"),
        description=j["description"],
        required_skills=j.get("required_skills", []),
        application_url=j["application_url"],
        posted_at=posted_at
    )


@router.get("/{job_id}/match", response_model=JobMatchRead)
async def compute_job_match(
    job_id: str,
    resume_id: Optional[str] = Query(None),
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    job = ProviderRegistry.get_job_by_id(job_id)
    if not job:
        raise HTTPException(status_code=404, detail="Job posting not found")

    req_skills = job.get("required_skills", [])
    
    # Default skills & projects for Backend Resume
    resume_skills = ["Python", "FastAPI", "PostgreSQL", "Docker"]
    resume_projects = ["Async REST API Platform"]
    used_resume_id = resume_id or "default-active-resume"

    # Dynamic profile extraction based on selected resume
    if resume_id:
        if "Machine Learning" in resume_id or "ML" in resume_id:
            resume_skills = ["PyTorch", "TensorFlow", "Scikit-Learn", "Python", "Data Processing"]
            resume_projects = ["Computer Vision Classifier"]
        elif "Software Engineer" in resume_id or "Full" in resume_id:
            resume_skills = ["JavaScript", "React", "Node.js", "MongoDB", "Git"]
            resume_projects = ["E-Commerce Web Portal"]
        else:
            # Query Database for specific user resume
            res_stmt = await db.execute(select(Resume).where(Resume.id == resume_id, Resume.user_id == current_user.id))
            resume = res_stmt.scalars().first()
            if resume:
                if resume.parsed_skills_json:
                    resume_skills = json.loads(resume.parsed_skills_json)
                if resume.parsed_projects_json:
                    resume_projects = json.loads(resume.parsed_projects_json)

    strong_matches = []
    missing_skills = []

    for sk in req_skills:
        if any(sk.lower() in r_sk.lower() or r_sk.lower() in sk.lower() for r_sk in resume_skills):
            strong_matches.append(sk)
        else:
            missing_skills.append(sk)

    skill_score = round((len(strong_matches) / max(1, len(req_skills))) * 100, 1)
    
    # Dynamic experience & semantic match based on skill alignment
    if skill_score > 75:
        exp_score = 90.0
        semantic_score = 88.0
    elif skill_score > 40:
        exp_score = 65.0
        semantic_score = 60.0
    else:
        exp_score = 45.0
        semantic_score = 40.0

    overall_match = round((skill_score * 0.5) + (exp_score * 0.3) + (semantic_score * 0.2), 1)

    evidence_trace = []
    for match in strong_matches:
        proj_ref = resume_projects[0] if resume_projects else "Extracted Resume Skills"
        evidence_trace.append({
            "skill": match,
            "source": f"Found in {proj_ref}"
        })

    return JobMatchRead(
        job_id=job_id,
        resume_id=used_resume_id,
        overall_match=overall_match,
        skill_match_score=skill_score,
        experience_match_score=exp_score,
        semantic_match_score=semantic_score,
        strong_matches=strong_matches,
        partial_matches=[],
        missing_skills=missing_skills,
        evidence_trace=evidence_trace
    )


@router.post("/applications", response_model=JobApplicationRead, status_code=status.HTTP_201_CREATED)
async def create_job_application(
    req: JobApplicationCreate,
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    job = ProviderRegistry.get_job_by_id(req.job_id)
    job_title = job["title"] if job else "Software Engineer"
    company_name = job["company_name"] if job else "Tech Company"

    app_id = str(uuid.uuid4())
    application = JobApplication(
        id=app_id,
        user_id=current_user.id,
        job_id=req.job_id,
        resume_id=req.resume_id,
        status=req.status,
        applied_at=datetime.utcnow(),
        notes=req.notes
    )
    db.add(application)
    await db.commit()

    return JobApplicationRead(
        id=application.id,
        job_id=req.job_id,
        job_title=job_title,
        company_name=company_name,
        status=application.status,
        applied_at=application.applied_at,
        notes=application.notes
    )


@router.get("/applications", response_model=List[JobApplicationRead])
async def list_job_applications(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = select(JobApplication).where(JobApplication.user_id == current_user.id).order_by(JobApplication.applied_at.desc())
    res = await db.execute(stmt)
    apps = res.scalars().all()

    result: List[JobApplicationRead] = []
    for a in apps:
        j = ProviderRegistry.get_job_by_id(a.job_id)
        job_title = j["title"] if j else "Software Engineer"
        company_name = j["company_name"] if j else "Tech Company"

        result.append(JobApplicationRead(
            id=a.id,
            job_id=a.job_id,
            job_title=job_title,
            company_name=company_name,
            status=a.status,
            applied_at=a.applied_at,
            notes=a.notes
        ))
    return result
