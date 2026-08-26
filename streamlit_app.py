import os
import sys
import streamlit as st

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from auth_widget import render_sidebar_auth

st.set_page_config(
    page_title="CareerLens AI - Personal Career Intelligence",
    page_icon="🔍",
    layout="wide",
    initial_sidebar_state="expanded"
)

render_sidebar_auth()

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
    .header-box {
        background: rgba(30, 41, 59, 0.85);
        backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.15);
        border-radius: 16px;
        padding: 28px;
        margin-bottom: 28px;
        box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.4);
    }
    .title-gradient {
        background: linear-gradient(90deg, #38bdf8 0%, #818cf8 50%, #c084fc 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        font-size: 2.8rem;
        font-weight: 800;
        margin-bottom: 6px;
    }
    .glass-card {
        background: rgba(30, 41, 59, 0.7);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.12);
        border-radius: 14px;
        padding: 24px;
        margin-bottom: 16px;
    }
    [data-testid="stPageLink-NavLink"] {
        background: linear-gradient(90deg, #2563eb 0%, #7c3aed 100%) !important;
        color: #ffffff !important;
        border-radius: 10px !important;
        padding: 12px 20px !important;
        font-weight: 700 !important;
        font-size: 1.05rem !important;
        text-align: center !important;
        margin-top: 10px !important;
        border: 1px solid #60a5fa !important;
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3) !important;
    }
    [data-testid="stPageLink-NavLink"] p, [data-testid="stPageLink-NavLink"] span {
        color: #ffffff !important;
        font-weight: 700 !important;
    }
</style>
""", unsafe_allow_html=True)

st.markdown("""
<div class="header-box">
    <div class="title-gradient">🔍 CareerLens AI</div>
    <div style="color: #cbd5e1; font-size: 1.25rem; font-weight: 500; margin-top: 8px;">
        An Explainable and Fair Agentic AI System for Personal Career Intelligence & Live AI Mock Interviews
    </div>
</div>
""", unsafe_allow_html=True)

if st.session_state.get("user_authenticated"):
    st.success(f"👋 Welcome back, **{st.session_state['user_name']}** ({st.session_state['user_email']})!")

st.markdown("## 🚀 Explore CareerLens AI Modules")
st.caption("Click any button below or select from the left sidebar menu to open a module:")

col1, col2 = st.columns(2)

with col1:
    st.markdown("""
    <div class="glass-card">
        <h3>🎯 1. AI Mock Interview Practice</h3>
        <p style="color: #cbd5e1;">Live WebCam video stream and real-time speech-to-text microphone transcription with instant STAR framework scoring, WPM pace, and filler word detection.</p>
    </div>
    """, unsafe_allow_html=True)
    st.page_link("pages/1_AI_Mock_Interview.py", label="Launch AI Mock Interview Practice", icon="🎯", use_container_width=True)

    st.markdown("""
    <div class="glass-card" style="margin-top: 24px;">
        <h3>📄 2. Resume PDF Analyzer</h3>
        <p style="color: #cbd5e1;">Upload PDF resumes to extract technical skills, domain strengths, and profile readiness.</p>
    </div>
    """, unsafe_allow_html=True)
    st.page_link("pages/2_Resume_Analyzer.py", label="Open Resume Analyzer", icon="📄", use_container_width=True)

with col2:
    st.markdown("""
    <div class="glass-card">
        <h3>📊 3. Job Compatibility & Roadmap</h3>
        <p style="color: #cbd5e1;">Compare your candidate profile against target job descriptions, calculate match score %, and generate a 4-week learning roadmap.</p>
    </div>
    """, unsafe_allow_html=True)
    st.page_link("pages/3_Job_Match_and_Roadmap.py", label="Open Job Compatibility & Roadmap", icon="📊", use_container_width=True)

    st.markdown("""
    <div class="glass-card" style="margin-top: 24px;">
        <h3>💬 4. AI Career Coach</h3>
        <p style="color: #cbd5e1;">Interactive conversational AI assistant providing grounded career advice, interview strategy, and ATS resume tips.</p>
    </div>
    """, unsafe_allow_html=True)
    st.page_link("pages/4_AI_Career_Coach.py", label="Chat with AI Career Coach", icon="💬", use_container_width=True)
