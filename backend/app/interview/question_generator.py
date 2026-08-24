from typing import List, Dict, Any
from app.models.interview import InterviewType

class QuestionGenerator:
    """
    Generates non-generic, highly personalized interview questions derived directly
    from candidate resume skills, projects, target job role, and interview mode.
    """

    @staticmethod
    def generate_questions(
        target_role: str,
        interview_type: InterviewType,
        difficulty: str = "intermediate",
        skills: List[str] = None,
        projects: List[str] = None,
    ) -> List[Dict[str, Any]]:
        skills = skills or ["Python", "FastAPI", "PostgreSQL", "Docker"]
        projects = projects or ["Async REST API Platform"]

        questions: List[Dict[str, Any]] = []

        # 1. Resume Project Specific Question
        if projects:
            primary_proj = projects[0]
            questions.append({
                "question_order": len(questions) + 1,
                "question_text": f"Explain the high-level architecture of your '{primary_proj}' project mentioned in your resume. What key design choices did you make?",
                "question_type": "project",
                "difficulty": difficulty,
                "source_context": f"Derived from resume project: {primary_proj}"
            })
            questions.append({
                "question_order": len(questions) + 1,
                "question_text": f"What was the single biggest technical challenge you faced while implementing '{primary_proj}', and how did you resolve it?",
                "question_type": "project",
                "difficulty": difficulty,
                "source_context": f"Derived from resume project: {primary_proj}"
            })

        # 2. Tech Stack / Skill Specific Questions
        if "FastAPI" in skills or "Python" in skills:
            questions.append({
                "question_order": len(questions) + 1,
                "question_text": f"In your experience with Python & FastAPI, why did you choose FastAPI over Flask or Django? How do asynchronous endpoints (async/await) work under the hood?",
                "question_type": "technical",
                "difficulty": difficulty,
                "source_context": f"Targeted technical question for {target_role} (FastAPI/Python)"
            })
        
        if "PostgreSQL" in skills or "Database" in skills or "SQL" in skills:
            questions.append({
                "question_order": len(questions) + 1,
                "question_text": f"How do you handle database indexing, connection pooling, and slow query optimization in production PostgreSQL systems for a {target_role} role?",
                "question_type": "technical",
                "difficulty": difficulty,
                "source_context": "Targeted database optimization question"
            })

        # 3. System Design & Scalability
        questions.append({
            "question_order": len(questions) + 1,
            "question_text": f"Suppose your {target_role} backend receives a sudden 10x traffic spike. How would you scale the database, caching layer, and asynchronous worker queues?",
            "question_type": "system_design",
            "difficulty": difficulty,
            "source_context": "System design scalability question"
        })

        # 4. Behavioral & Problem-Solving (STAR Method)
        questions.append({
            "question_order": len(questions) + 1,
            "question_text": "Describe a scenario where you had a tight project deadline or conflicting requirement with a teammate. How did you prioritize tasks and communicate the trade-offs?",
            "question_type": "behavioral",
            "difficulty": difficulty,
            "source_context": "Behavioral STAR method question"
        })

        # Trim questions according to interview type
        if interview_type == InterviewType.QUICK_PRACTICE:
            return questions[:3]
        elif interview_type == InterviewType.TECHNICAL:
            return [q for q in questions if q["question_type"] in ["technical", "project", "system_design"]]
        elif interview_type == InterviewType.BEHAVIORAL:
            return [q for q in questions if q["question_type"] == "behavioral"] + [
                {
                    "question_order": 2,
                    "question_text": "Tell me about a time when you received constructive feedback on your code or design. How did you adapt?",
                    "question_type": "behavioral",
                    "difficulty": difficulty,
                    "source_context": "HR Behavioral question"
                }
            ]
        
        return questions
