import os
import sys
import streamlit as st

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from auth_widget import render_sidebar_auth


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
    [data-testid="stSidebar"] button {
        background: linear-gradient(90deg, #2563eb 0%, #7c3aed 100%) !important;
        color: #ffffff !important;
        border-radius: 8px !important;
        border: none !important;
    }
    [data-testid="stSidebar"] button p, [data-testid="stSidebar"] button span {
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
</style>
""", unsafe_allow_html=True)

if st.button("🏠 Back to Home Dashboard", key="btn_home_p4"):
    st.switch_page("streamlit_app.py")

if "chat_history" not in st.session_state:
    st.session_state["chat_history"] = [
        {"role": "assistant", "content": "Hello! I am your AI Career Coach. How can I help you with your career goals, resume strategy, or interview preparation today?"}
    ]

st.markdown("# 💬 Grounded AI Career Guidance Coach")
st.caption("Ask questions about career strategy, interview preparation, salary negotiation, or technical growth.")

for msg in st.session_state["chat_history"]:
    with st.chat_message(msg["role"]):
        st.write(msg["content"])

user_prompt = st.chat_input("Ask your career question (e.g. How should I prepare for a FastAPI system design interview?)...")

if user_prompt:
    st.session_state["chat_history"].append({"role": "user", "content": user_prompt})
    with st.chat_message("user"):
        st.write(user_prompt)

    prompt_lower = user_prompt.lower()
    if "fastapi" in prompt_lower or "backend" in prompt_lower or "interview" in prompt_lower:
        response_text = (
            "For a **FastAPI / Backend Engineer interview**, focus on these core areas:\n\n"
            "1. **AsyncIO & Event Loop**: Understand how non-blocking endpoints operate compared to synchronous WSGI frameworks (Flask/Django).\n"
            "2. **Pydantic V2 Validation**: Be ready to explain data schemas, field validators, and settings management.\n"
            "3. **Database Integration**: Explain SQLAlchemy async engines, connection pooling, and migration strategies using Alembic.\n"
            "4. **Authentication & Security**: Understand JWT access & refresh token rotation, bcrypt password hashing, and OAuth2 scopes."
        )
    elif "resume" in prompt_lower:
        response_text = (
            "To optimize your **Resume for AI Screening (ATS)**:\n\n"
            "1. Quantify achievements with metrics (e.g., 'Optimized database queries reducing p99 latency by 35%').\n"
            "2. Include concrete technology stacks rather than generic claims.\n"
            "3. Align your project technical descriptions with your target job description keywords."
        )
    else:
        response_text = (
            f"Great question! Based on your target goals in software engineering, I recommend focusing on building end-to-end projects with clear documentation, "
            f"practicing adaptive technical questions using the STAR framework, and maintaining an updated GitHub portfolio."
        )

    st.session_state["chat_history"].append({"role": "assistant", "content": response_text})
    with st.chat_message("assistant"):
        st.write(response_text)
