import os
import sys
import streamlit as st

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

st.markdown("""
<style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap');

    html, body, .stApp {
        font-family: 'Inter', sans-serif !important;
        background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #0f172a 100%);
        color: #f8fafc !important;
    }
    p, label, div,
    .stMarkdown, .stText, [data-testid="stWidgetLabel"] p {
        color: #f8fafc !important;
        font-family: 'Inter', sans-serif !important;
    }
    h1, h2, h3, h4, h5, h6 {
        font-family: 'Outfit', sans-serif !important;
        color: #ffffff !important;
        font-weight: 700 !important;
    }

    /* Fix Streamlit Material Icons Text Overlay */
    .material-symbols-outlined, .material-icons, [class*="material-symbols"], [data-testid="stIcon"] {
        font-family: 'Material Symbols Outlined', 'Material Icons' !important;
    }

    /* Captions & Subtitles */
    .stCaption, [data-testid="stCaptionContainer"] p, [data-testid="stCaptionContainer"] {
        color: #cbd5e1 !important;
        font-size: 0.98rem !important;
        font-weight: 500 !important;
    }

    /* Force Dark Navy Sidebar with High Contrast White Text */
    [data-testid="stSidebar"] {
        background-color: #0f172a !important;
        border-right: 1px solid rgba(255, 255, 255, 0.12) !important;
    }
    [data-testid="stSidebar"] p,
    [data-testid="stSidebar"] span,
    [data-testid="stSidebar"] label,
    [data-testid="stSidebar"] h1,
    [data-testid="stSidebar"] h2,
    [data-testid="stSidebar"] h3,
    [data-testid="stSidebar"] h4,
    [data-testid="stSidebar"] div,
    [data-testid="stSidebar"] .stMarkdown {
        color: #f8fafc !important;
    }
    [data-testid="stSidebar"] input {
        background-color: #1e293b !important;
        color: #ffffff !important;
        border: 1px solid #475569 !important;
        border-radius: 6px !important;
    }

    /* Banner Container */
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
        font-family: 'Outfit', sans-serif !important;
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
        margin-bottom: 14px;
    }

    /* Primary Buttons */
    .stButton > button {
        background: linear-gradient(90deg, #2563eb 0%, #7c3aed 100%) !important;
        color: #ffffff !important;
        font-family: 'Outfit', sans-serif !important;
        font-weight: 700 !important;
        border-radius: 10px !important;
        padding: 12px 24px !important;
        font-size: 1.05rem !important;
        border: 1px solid #60a5fa !important;
        box-shadow: 0 4px 14px rgba(37, 99, 235, 0.35) !important;
    }
    .stButton > button p, .stButton > button span {
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
    if st.button("🚀 Launch AI Mock Interview Practice", key="btn_nav_h1", use_container_width=True):
        st.session_state["target_page"] = "pages/1_AI_Mock_Interview.py"
        st.rerun()

    st.markdown("""
    <div class="glass-card" style="margin-top: 24px;">
        <h3>📄 2. Resume PDF Analyzer</h3>
        <p style="color: #cbd5e1;">Upload PDF resumes to extract technical skills, domain strengths, and profile readiness.</p>
    </div>
    """, unsafe_allow_html=True)
    if st.button("📄 Open Resume Analyzer", key="btn_nav_h2", use_container_width=True):
        st.session_state["target_page"] = "pages/2_Resume_Analyzer.py"
        st.rerun()

with col2:
    st.markdown("""
    <div class="glass-card">
        <h3>📊 3. Job Compatibility & Roadmap</h3>
        <p style="color: #cbd5e1;">Compare your candidate profile against target job descriptions, calculate match score %, and generate a 4-week learning roadmap.</p>
    </div>
    """, unsafe_allow_html=True)
    if st.button("📊 Open Job Compatibility & Roadmap", key="btn_nav_h3", use_container_width=True):
        st.session_state["target_page"] = "pages/3_Job_Match_and_Roadmap.py"
        st.rerun()

    st.markdown("""
    <div class="glass-card" style="margin-top: 24px;">
        <h3>💬 4. AI Career Coach</h3>
        <p style="color: #cbd5e1;">Interactive conversational AI assistant providing grounded career advice, interview strategy, and ATS resume tips.</p>
    </div>
    """, unsafe_allow_html=True)
    if st.button("💬 Chat with AI Career Coach", key="btn_nav_h4", use_container_width=True):
        st.session_state["target_page"] = "pages/4_AI_Career_Coach.py"
        st.rerun()
