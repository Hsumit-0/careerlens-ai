import os
import sys
import streamlit as st

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

st.set_page_config(
    page_title="CareerLens AI - Personal Career Intelligence",
    page_icon="🔍",
    layout="wide",
    initial_sidebar_state="expanded"
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
        margin-bottom: 20px;
        transition: transform 0.2s ease;
    }
</style>
""", unsafe_allow_html=True)

# Main Banner
st.markdown("""
<div class="header-box">
    <div class="title-gradient">🔍 CareerLens AI</div>
    <div style="color: #cbd5e1; font-size: 1.25rem; font-weight: 500; margin-top: 8px;">
        An Explainable and Fair Agentic AI System for Personalized Career Intelligence & Live Mock Interviews
    </div>
</div>
""", unsafe_allow_html=True)

st.markdown("## 👈 Select a Module from the Sidebar Menu")
st.caption("Use the sidebar on the left to navigate to any dedicated feature page:")

c1, c2 = st.columns(2)

with c1:
    st.markdown("""
    <div class="glass-card">
        <h3>🎯 1. AI Mock Interview Practice</h3>
        <p style="color: #cbd5e1;">Live WebCam video stream and real-time speech-to-text microphone transcription with instant STAR framework scoring, WPM pace, and filler word detection.</p>
    </div>
    <div class="glass-card">
        <h3>📄 2. Resume PDF Analyzer</h3>
        <p style="color: #cbd5e1;">Upload PDF resumes to extract technical skills, domain strengths, and profile readiness.</p>
    </div>
    """, unsafe_allow_html=True)

with c2:
    st.markdown("""
    <div class="glass-card">
        <h3>📊 3. Job Compatibility & Roadmap</h3>
        <p style="color: #cbd5e1;">Compare your candidate profile against target job descriptions, calculate match score %, and generate a 4-week learning roadmap.</p>
    </div>
    <div class="glass-card">
        <h3>💬 4. AI Career Coach</h3>
        <p style="color: #cbd5e1;">Interactive conversational AI assistant providing grounded career advice, interview strategy, and ATS resume tips.</p>
    </div>
    """, unsafe_allow_html=True)
