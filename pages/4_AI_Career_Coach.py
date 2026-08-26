import os
import sys
import streamlit as st

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

st.markdown("""
<style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap');

    html, body, [class*="css"], .stApp {
        font-family: 'Inter', sans-serif !important;
        background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #0f172a 100%);
        color: #f8fafc !important;
    }
    p, span, label, div,
    .stMarkdown, .stText, [data-testid="stWidgetLabel"] p {
        color: #f8fafc !important;
        font-family: 'Inter', sans-serif !important;
    }
    h1, h2, h3, h4, h5, h6 {
        font-family: 'Outfit', sans-serif !important;
        color: #ffffff !important;
        font-weight: 700 !important;
    }
    .glass-card {
        background: rgba(30, 41, 59, 0.75);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.12);
        border-radius: 14px;
        padding: 22px;
        margin-bottom: 18px;
    }
    [data-testid="stChatMessage"] {
        background-color: rgba(30, 41, 59, 0.8) !important;
        border: 1px solid rgba(255, 255, 255, 0.1) !important;
        border-radius: 12px !important;
        padding: 16px !important;
        margin-bottom: 12px !important;
    }
</style>
""", unsafe_allow_html=True)

if st.button("🏠 Back to Home Dashboard", key="btn_home_p4"):
    st.session_state["target_page"] = "pages/0_Home.py"
    st.rerun()

if "chat_history" not in st.session_state:
    st.session_state["chat_history"] = [
        {"role": "assistant", "content": "Hello! I am your AI Career Coach. Ask me any question about technical interviews, system design, resume ATS optimization, framework concepts, or salary negotiation!"}
    ]

st.markdown("# 💬 Grounded AI Career Guidance Coach")
st.caption("Ask questions about career strategy, interview preparation, salary negotiation, or technical growth.")

for msg in st.session_state["chat_history"]:
    with st.chat_message(msg["role"]):
        st.write(msg["content"])

user_prompt = st.chat_input("Ask your career or technical question (e.g., How do I explain database indexing or STAR framework?)...")


def generate_ai_career_response(user_question: str) -> str:
    """Intelligent multi-category AI Career Coach response generator."""
    q = user_question.lower().strip()
    
    # 1. System Design / Architecture / Scaling
    if any(k in q for k in ["system design", "scale", "latency", "microservices", "database indexing", "load balancer", "sharding", "caching", "redis"]):
        return (
            "### 🏗️ AI Career Coach: System Design & Architecture Guidance\n\n"
            "To excel in **System Design & Scalability** discussions, structure your answers using the **4-Step Framework**:\n\n"
            "1. **Requirements & Constraints**: Clarify functional requirements (e.g., read vs. write volume) and non-functional goals (Availability vs. Consistency - CAP Theorem).\n"
            "2. **High-Level Architecture**: Define client layer, API Gateway/Load Balancer (Nginx), stateless App Servers, and Database tier.\n"
            "3. **Data Layer & Caching**: Explain primary storage (PostgreSQL/MongoDB) vs In-Memory Caching (Redis/Memcached) for hot data to reduce database load by 80%+.\n"
            "4. **Scalability & Bottleneck Mitigation**: Discuss horizontal auto-scaling, database read-replicas, connection pooling (`pgbouncer`), and asynchronous task queues (Celery/RabbitMQ).\n\n"
            "💡 *Pro-Tip*: Always mention trade-offs (e.g., latency vs. storage cost, immediate consistency vs. eventual consistency)."
        )
        
    # 2. Python / FastAPI / Async Frameworks
    elif any(k in q for k in ["fastapi", "python", "django", "flask", "async", "asyncio", "pydantic", "sqlalchemy"]):
        return (
            "### 🐍 AI Career Coach: Python & FastAPI Technical Mastery\n\n"
            "Here are the essential concepts to highlight for **Python/FastAPI Engineering**:\n\n"
            "1. **Asynchronous Architecture (`async/await`)**: Explain how FastAPI utilizes Starlette and asyncio event loops to handle high I/O concurrency without blocking thread pools.\n"
            "2. **Data Validation with Pydantic V2**: Emphasize strict type safety, schema definitions, custom `@field_validator` functions, and fast Rust-backed serialization.\n"
            "3. **Database Session Management**: Detail SQLAlchemy 2.0 async sessions (`async_sessionmaker`), lazy vs eager loading (`selectinload`), and migration safety with Alembic.\n"
            "4. **API Security**: Highlight OAuth2 Password Bearer flow, JWT access token expiry, refresh token rotation, and `passlib`/`bcrypt` password hashing.\n\n"
            "🎯 *Action Step*: Prepare code examples showing custom dependency injection (`Depends`) and global exception handlers."
        )

    # 3. Resume / ATS Optimization
    elif any(k in q for k in ["resume", "cv", "ats", "format", "bullet", "projects", "skill"]):
        return (
            "### 📄 AI Career Coach: ATS Resume Strategy & Optimization\n\n"
            "To pass Applicant Tracking Systems (ATS) and impress hiring managers, follow these rules:\n\n"
            "1. **Use the Action-Metric-Result Format**: Start bullet points with strong action verbs and quantify achievements.\n"
            "   * *Weak*: 'Built backend APIs for the platform.'\n"
            "   * *Strong*: 'Designed and deployed 15+ RESTful APIs using FastAPI and PostgreSQL, reducing p99 response latency by 35%.'\n"
            "2. **Keyword Optimization**: Extract technical keywords directly from target job descriptions (e.g., Pytest, Docker, CI/CD, Redis) and include them in your Skills and Experience sections.\n"
            "3. **Clean Technical Formatting**: Keep your PDF simple, single/double column, without complex floating images or graphics that obscure ATS text parsing.\n"
            "4. **Highlight Key Projects**: For entry/mid level roles, detail architecture choices, tech stack badges, and GitHub repository links."
        )

    # 4. Interview Preparation / STAR Method / Behavioral Questions & Salary
    elif any(k in q for k in ["interview", "behavioral", "star", "tell me about yourself", "weakness", "conflict", "salary", "negotiate"]):
        return (
            "### 🎯 AI Career Coach: Behavioral & STAR Method Mastery\n\n"
            "Mastering behavioral and situational interview questions requires the **STAR Method**:\n\n"
            "* **Situation (S)**: Briefly set the context (e.g., 'During my work on a high-traffic e-commerce microservice project...').\n"
            "* **Task (T)**: Describe the specific responsibility or challenge faced (e.g., 'We experienced a sudden 300% database bottleneck prior to launch...').\n"
            "* **Action (A)**: Detail the concrete steps YOU took (e.g., 'I profiled the queries using `EXPLAIN ANALYZE`, added composite indexes, and implemented Redis caching...').\n"
            "* **Result (R)**: Quantify the outcome (e.g., 'This reduced query execution time from 1.2s to 45ms and allowed 10k concurrent users.').\n\n"
            "💬 *Salary Negotiation Tip*: Never give a single baseline number first. Research market rates (Glassdoor/Levels.fyi) and provide a range based on total compensation."
        )

    # 5. Frontend & Mobile Development (Flutter, React, Dart, JavaScript)
    elif any(k in q for k in ["flutter", "mobile", "react", "dart", "javascript", "state management", "riverpod"]):
        return (
            "### 📱 AI Career Coach: Mobile & Frontend Development Excellence\n\n"
            "Key strategies for **Flutter & Web/Mobile Frontend Engineers**:\n\n"
            "1. **State Management Patterns**: Be prepared to explain Riverpod/Bloc architecture, immutability, notifier providers, and reactive UI updates.\n"
            "2. **Clean Architecture & Repository Pattern**: Structure your codebase into `core/`, `features/` (data, domain, presentation layers) for maintainability and modular testing.\n"
            "3. **Networking & Security**: Discuss Dio HTTP interceptors for automatic Bearer token injection, refresh token queuing, and `flutter_secure_storage` for encrypted secrets.\n"
            "4. **UI Performance**: Minimize widget rebuilds, use `const` constructors, lazy-load list views (`ListView.builder`), and compress font/image assets."
        )

    # 6. DevOps, Cloud & CI/CD (Docker, AWS, Kubernetes, Deploy)
    elif any(k in q for k in ["docker", "devops", "aws", "deploy", "ci/cd", "kubernetes", "cloud", "render"]):
        return (
            "### ☁️ AI Career Coach: Cloud & DevOps Best Practices\n\n"
            "For Cloud & Containerization readiness:\n\n"
            "1. **Multi-Stage Docker Builds**: Minimize final image footprint by separating build-time dependencies from production Python slim runtime.\n"
            "2. **Dynamic Environment Configuration**: Avoid hardcoding ports or secrets; use environment variables (`PORT`, `DATABASE_URL`, `JWT_SECRET`) parsed via Pydantic `BaseSettings`.\n"
            "3. **Automated Pipelines**: Implement CI/CD checks (Pytest, Flutter analyze, linting) on push to main branch.\n"
            "4. **Database Connection Pooling**: Ensure production PostgreSQL databases handle connection limits gracefully under load."
        )

    # 7. General / Catch-All Intelligent Career Guidance
    else:
        return (
            f"### 💡 AI Career Coach: Personalized Career Strategy\n\n"
            f"Thank you for asking about **'{user_question}'**! Here is my tailored guidance for your career progression:\n\n"
            f"1. **Core Technical Focus**: Focus on deep understanding of foundational concepts rather than surface-level framework usage.\n"
            f"2. **Demonstrable Proof**: Build 2-3 end-to-end open-source projects on GitHub with comprehensive README documentation, architectural diagrams, and automated unit tests.\n"
            f"3. **Structured Communication**: Practice explaining technical concepts clearly using plain language, trade-off comparisons, and concrete performance metrics.\n"
            f"4. **Continuous Learning Roadmap**: Allocate 3-5 hours per week to targeted skill acquisition in missing tech stack keywords."
        )


if user_prompt:
    st.session_state["chat_history"].append({"role": "user", "content": user_prompt})
    with st.chat_message("user"):
        st.write(user_prompt)

    response_text = generate_ai_career_response(user_prompt)

    st.session_state["chat_history"].append({"role": "assistant", "content": response_text})
    with st.chat_message("assistant"):
        st.write(response_text)
