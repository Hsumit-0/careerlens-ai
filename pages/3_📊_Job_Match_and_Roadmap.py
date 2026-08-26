import os
import sys
import streamlit as st

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

st.set_page_config(
    page_title="Job Match & Roadmap - CareerLens AI",
    page_icon="📊",
    layout="wide"
)

st.markdown("""
<style>
    .stApp {
        background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #0f172a 100%);
        color: #f8fafc !important;
    }
    p, span, label, div, h1, h2, h3, h4, h5, h6,
    .stMarkdown, .stText, [data-testid="stWidgetLabel"] p {
        color: #f8fafc !important;
    }
    .glass-card {
        background: rgba(30, 41, 59, 0.75);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.12);
        border-radius: 14px;
        padding: 22px;
        margin-bottom: 18px;
    }
    .score-badge {
        background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
        color: #ffffff !important;
        font-size: 2.2rem;
        font-weight: 800;
        border-radius: 14px;
        padding: 14px 24px;
        display: inline-block;
        text-align: center;
    }
</style>
""", unsafe_allow_html=True)

st.markdown("# 📊 Granular Job Compatibility & Learning Roadmap")
st.caption("Match your candidate profile against target job descriptions to identify skill gaps and generate a 4-week learning roadmap.")

col_job1, col_job2 = st.columns([1, 1])

with col_job1:
    st.markdown("<div class='glass-card'>", unsafe_allow_html=True)
    st.markdown("### 🎯 Target Job Description")
    job_title_input = st.text_input("Target Job Title", "Senior Backend Developer (Python / FastAPI)")
    jd_text = st.text_area(
        "Paste Job Description",
        height=220,
        value="We are looking for a Senior Backend Developer proficient in Python, FastAPI, PostgreSQL, Redis caching, AsyncIO, Docker containerization, Pytest, and CI/CD pipelines."
    )
    match_btn = st.button("⚡ Analyze Compatibility & Generate Roadmap", use_container_width=True)
    st.markdown("</div>", unsafe_allow_html=True)

with col_job2:
    if match_btn or jd_text:
        req_keywords = ["Python", "FastAPI", "PostgreSQL", "Redis", "AsyncIO", "Docker", "Pytest", "CI/CD"]
        user_skills = ["Python", "FastAPI", "PostgreSQL", "Docker", "Pytest"]

        matched = [k for k in req_keywords if k.lower() in user_skills or k.lower() in jd_text.lower()]
        missing = [k for k in req_keywords if k not in matched]

        match_score = int((len(matched) / max(len(req_keywords), 1)) * 100)

        st.markdown("<div class='glass-card'>", unsafe_allow_html=True)
        st.markdown("### 🏆 Compatibility Score")
        st.markdown(f"<div class='score-badge'>{match_score}% Match</div>", unsafe_allow_html=True)

        st.markdown("#### ✅ Matched Key Skills")
        st.write(", ".join([f"✓ `{s}`" for s in matched]))

        if missing:
            st.markdown("#### ⚠️ Recommended Skills to Acquire")
            st.write(", ".join([f"⚡ `{s}`" for s in missing]))

        st.markdown("#### 🗺️ 4-Week Personal Career Roadmap")
        st.markdown("""
        * **Week 1 (Caching & Data Structures)**: Master Redis caching patterns, pub/sub, and async cache invalidation.
        * **Week 2 (Containerization & CI/CD)**: Set up Docker multi-stage builds, GitHub Actions / Codemagic deployment pipelines.
        * **Week 3 (Advanced Testing)**: Write integration tests with Pytest, mock async engines, and achieve 90%+ code coverage.
        * **Week 4 (System Design)**: Practice scaling REST APIs to 10k requests/sec and designing fault-tolerant architectures.
        """)
        st.markdown("</div>", unsafe_allow_html=True)
