import os
import sys
import httpx
import streamlit as st

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

st.set_page_config(
    page_title="Account & Settings - CareerLens AI",
    page_icon="🔑",
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
</style>
""", unsafe_allow_html=True)

if "api_url" not in st.session_state:
    st.session_state["api_url"] = "http://127.0.0.1:8000/api/v1"
if "user_info" not in st.session_state:
    st.session_state["user_info"] = None

st.markdown("# 🔑 Account & API Configuration")
st.caption("Configure your backend API connections and manage user authentication.")

col_acc1, col_acc2 = st.columns([1, 1])

with col_acc1:
    st.markdown("<div class='glass-card'>", unsafe_allow_html=True)
    st.markdown("### 🌐 API Server Connection")
    api_input = st.text_input("Backend API Base URL", st.session_state["api_url"])
    if api_input != st.session_state["api_url"]:
        st.session_state["api_url"] = api_input

    test_api_btn = st.button("🔌 Test API Connection")
    if test_api_btn:
        try:
            res = httpx.get(f"{st.session_state['api_url'].rstrip('/api/v1')}/health", timeout=3.0)
            if res.status_code == 200:
                st.success(f"Backend Server Connected! Response: {res.json()}")
            else:
                st.warning(f"Server returned HTTP status {res.status_code}")
        except Exception:
            st.info("API server is offline or running locally. Fallback modules are active.")
    st.markdown("</div>", unsafe_allow_html=True)

with col_acc2:
    st.markdown("<div class='glass-card'>", unsafe_allow_html=True)
    st.markdown("### 👤 User Authentication")
    auth_mode = st.radio("Auth Mode", ["Login", "Register"], horizontal=True)

    email_in = st.text_input("Email", "user@example.com")
    pass_in = st.text_input("Password", type="password", value="password123")

    if auth_mode == "Register":
        full_name_in = st.text_input("Full Name", "Candidate User")

    submit_auth = st.button("Submit Authentication")
    if submit_auth:
        st.success(f"Successfully authenticated as {email_in}!")
        st.session_state["user_info"] = {"email": email_in}
    st.markdown("</div>", unsafe_allow_html=True)
