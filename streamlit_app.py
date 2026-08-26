import os
import sys
import streamlit as st
from auth_widget import render_sidebar_auth

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Page Configuration
st.set_page_config(
    page_title="CareerLens AI - Personal Career Intelligence",
    page_icon="🔍",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Define Official Streamlit Page Objects
p_home = st.Page("pages/0_Home.py", title="Home Overview", icon="🏠", default=True)
p_interview = st.Page("pages/1_AI_Mock_Interview.py", title="AI Mock Interview", icon="🎯")
p_resume = st.Page("pages/2_Resume_Analyzer.py", title="Resume Analyzer", icon="📄")
p_roadmap = st.Page("pages/3_Job_Match_and_Roadmap.py", title="Job Match & Roadmap", icon="📊")
p_coach = st.Page("pages/4_AI_Career_Coach.py", title="AI Career Coach", icon="💬")

# Check for dynamic target page request
if st.session_state.get("target_page"):
    target = st.session_state.pop("target_page")
    page_map = {
        "pages/1_AI_Mock_Interview.py": p_interview,
        "pages/2_Resume_Analyzer.py": p_resume,
        "pages/3_Job_Match_and_Roadmap.py": p_roadmap,
        "pages/4_AI_Career_Coach.py": p_coach,
    }
    if target in page_map:
        st.switch_page(page_map[target])

pg = st.navigation({
    "CareerLens AI Modules": [p_home, p_interview, p_resume, p_roadmap, p_coach]
})

render_sidebar_auth()
pg.run()
