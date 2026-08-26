from abc import ABC, abstractmethod
from typing import List, Dict, Any, Optional

class JobProvider(ABC):
    """
    Abstract Base Class for modular job providers.
    Supports official APIs, authorized integrations, RSS feeds, and external providers.
    """

    @abstractmethod
    def search_jobs(
        self,
        query: Optional[str] = None,
        location: Optional[str] = None,
        remote_only: bool = False,
        experience_level: Optional[str] = None,
        job_type: Optional[str] = None,
        page: int = 1,
        limit: int = 10,
    ) -> List[Dict[str, Any]]:
        pass

    @abstractmethod
    def get_job_details(self, job_id: str) -> Optional[Dict[str, Any]]:
        pass

    @abstractmethod
    def get_provider_name(self) -> str:
        pass


class DevJobProvider(JobProvider):
    """
    Official Development & Seed Provider serving structured job opportunities with location-wise localized currencies.
    """

    _SEED_JOBS = [
        {
            "id": "job-verizon-102",
            "external_id": "ver-back-94",
            "provider": "Verizon India Careers",
            "title": "Backend Developer",
            "company_name": "Verizon",
            "location": "Bangalore, India",
            "work_type": "Remote",
            "experience_level": "Mid Level",
            "salary_range": "₹18,00,000 - ₹25,00,000 / yr",
            "currency": "INR",
            "description": "Verizon India is seeking a highly motivated Technical Backend Engineer to build async REST API platforms, database connection pools, and microservices in Bangalore.",
            "required_skills": ["Python", "FastAPI", "PostgreSQL", "Docker", "AWS", "CI/CD"],
            "application_url": "https://www.verizon.com/about/work/jobs",
            "posted_at": "2026-08-26T08:30:00Z"
        },
        {
            "id": "job-tcs-106",
            "external_id": "tcs-ai-99",
            "provider": "TCS Official Careers",
            "title": "Full Stack Developer",
            "company_name": "Tata Consultancy Services",
            "location": "Hyderabad, India",
            "work_type": "Hybrid",
            "experience_level": "Fresher",
            "salary_range": "₹6,50,000 - ₹9,50,000 / yr",
            "currency": "INR",
            "description": "TCS AI Innovation Hub in Hyderabad is hiring entry-level software developers proficient in Python, Flutter, PostgreSQL, and Web APIs.",
            "required_skills": ["Python", "Flutter", "PostgreSQL", "REST APIs", "Git"],
            "application_url": "https://www.tcs.com/careers",
            "posted_at": "2026-08-26T07:10:00Z"
        },
        {
            "id": "job-google-101",
            "external_id": "goog-eng-97",
            "provider": "Google Careers",
            "title": "Senior Software Engineer",
            "company_name": "Google",
            "location": "Mountain View, CA, USA",
            "work_type": "Hybrid",
            "experience_level": "Senior",
            "salary_range": "$160,000 - $220,000 / yr",
            "currency": "USD",
            "description": "Designing high-throughput distributed microservices, connection pooling, and cloud architecture using Python, FastAPI, and Kubernetes.",
            "required_skills": ["Python", "FastAPI", "PostgreSQL", "Docker", "Kubernetes", "System Design"],
            "application_url": "https://careers.google.com/jobs/results/",
            "posted_at": "2026-08-25T10:00:00Z"
        },
        {
            "id": "job-intel-103",
            "external_id": "intel-cloud-95",
            "provider": "Intel Careers",
            "title": "Cloud Software Engineer",
            "company_name": "Intel",
            "location": "Santa Clara, CA, USA",
            "work_type": "On-site",
            "experience_level": "Entry Level",
            "salary_range": "$120,000 - $150,000 / yr",
            "currency": "USD",
            "description": "Building next-generation cloud infrastructure, Docker containerization pipelines, and scalable APIs for AI acceleration workloads.",
            "required_skills": ["Python", "Docker", "Linux", "REST APIs", "C++", "Git"],
            "application_url": "https://jobs.intel.com/",
            "posted_at": "2026-08-26T09:15:00Z"
        },
        {
            "id": "job-hays-105",
            "external_id": "hays-pm-92",
            "provider": "HAYS Recruitment UK",
            "title": "Technical Product Manager",
            "company_name": "HAYS",
            "location": "London, UK",
            "work_type": "Hybrid",
            "experience_level": "Senior",
            "salary_range": "£75,000 - £95,000 / yr",
            "currency": "GBP",
            "description": "Leading product development lifecycle for enterprise software solutions and developer tools in London.",
            "required_skills": ["Project Mgmt", "Agile", "System Design", "Communication"],
            "application_url": "https://www.hays.com/jobs",
            "posted_at": "2026-08-23T11:45:00Z"
        },
        {
            "id": "job-sap-107",
            "external_id": "sap-eng-91",
            "provider": "SAP Careers Europe",
            "title": "AI Platform Engineer",
            "company_name": "SAP",
            "location": "Berlin, Germany",
            "work_type": "Remote",
            "experience_level": "Mid Level",
            "salary_range": "€70,000 - €90,000 / yr",
            "currency": "EUR",
            "description": "Building cloud-native machine learning pipeline orchestrators and scalable REST microservices across SAP Business Technology Platform.",
            "required_skills": ["Python", "PyTorch", "Docker", "FastAPI", "Kubernetes"],
            "application_url": "https://jobs.sap.com/",
            "posted_at": "2026-08-25T16:00:00Z"
        }
    ]

    def search_jobs(
        self,
        query: Optional[str] = None,
        location: Optional[str] = None,
        remote_only: bool = False,
        experience_level: Optional[str] = None,
        job_type: Optional[str] = None,
        page: int = 1,
        limit: int = 10,
    ) -> List[Dict[str, Any]]:
        results = self._SEED_JOBS

        if query:
            q_lower = query.lower()
            results = [
                j for j in results
                if q_lower in j["title"].lower()
                or q_lower in j["company_name"].lower()
                or q_lower in j["location"].lower()
                or any(q_lower in s.lower() for s in j["required_skills"])
            ]

        if location:
            loc_lower = location.lower()
            results = [j for j in results if loc_lower in j["location"].lower()]

        if remote_only:
            results = [j for j in results if j["work_type"].lower() == "remote"]

        if experience_level:
            results = [j for j in results if j["experience_level"].lower() == experience_level.lower()]

        start = (page - 1) * limit
        end = start + limit
        return results[start:end]

    def get_job_details(self, job_id: str) -> Optional[Dict[str, Any]]:
        for j in self._SEED_JOBS:
            if j["id"] == job_id:
                return j
        return None

    def get_provider_name(self) -> str:
        return "Official CareerLens Dev Provider"


class ProviderRegistry:
    _providers: List[JobProvider] = [DevJobProvider()]

    @classmethod
    def register_provider(cls, provider: JobProvider):
        cls._providers.append(provider)

    @classmethod
    def get_all_jobs(cls, **kwargs) -> List[Dict[str, Any]]:
        all_jobs = []
        for provider in cls._providers:
            all_jobs.extend(provider.search_jobs(**kwargs))
        return all_jobs

    @classmethod
    def get_job_by_id(cls, job_id: str) -> Optional[Dict[str, Any]]:
        for provider in cls._providers:
            job = provider.get_job_details(job_id)
            if job:
                return job
        return None
