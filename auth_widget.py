import streamlit as st

def render_sidebar_auth():
    """Renders sleek Login / Register / Logout user authentication widget in the sidebar with explicit high-contrast styling and modern fonts."""
    
    st.markdown("""
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap');

        /* Force Dark Navy Sidebar with Crisp White Text */
        [data-testid="stSidebar"] {
            background-color: #0f172a !important;
            border-right: 1px solid rgba(255, 255, 255, 0.12) !important;
            font-family: 'Inter', sans-serif !important;
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
            font-family: 'Inter', sans-serif !important;
        }
        [data-testid="stSidebar"] input {
            background-color: #1e293b !important;
            color: #ffffff !important;
            border: 1px solid #475569 !important;
            border-radius: 6px !important;
            font-family: 'Inter', sans-serif !important;
        }
        [data-testid="stSidebar"] button {
            background: linear-gradient(90deg, #2563eb 0%, #7c3aed 100%) !important;
            color: #ffffff !important;
            border-radius: 8px !important;
            border: none !important;
            font-family: 'Outfit', sans-serif !important;
            font-weight: 700 !important;
        }
        [data-testid="stSidebar"] button p, [data-testid="stSidebar"] button span {
            color: #ffffff !important;
            font-weight: 700 !important;
        }
    </style>
    """, unsafe_allow_html=True)

    if "user_authenticated" not in st.session_state:
        st.session_state["user_authenticated"] = False
    if "user_email" not in st.session_state:
        st.session_state["user_email"] = ""
    if "user_name" not in st.session_state:
        st.session_state["user_name"] = ""

    st.sidebar.markdown("---")

    if st.session_state["user_authenticated"]:
        st.sidebar.markdown(f"### 👤 Account Profile")
        st.sidebar.markdown(f"**{st.session_state['user_name']}**")
        st.sidebar.caption(f"📧 {st.session_state['user_email']}")
        
        if st.sidebar.button("🚪 Log Out", use_container_width=True):
            st.session_state["user_authenticated"] = False
            st.session_state["user_email"] = ""
            st.session_state["user_name"] = ""
            st.rerun()
    else:
        st.sidebar.markdown("### 🔐 User Authentication")
        auth_tab1, auth_tab2 = st.sidebar.tabs(["🔑 Login", "📝 Register"])
        
        with auth_tab1:
            login_email = st.text_input("Email", key="login_email_input", value="user@example.com")
            login_pass = st.text_input("Password", type="password", key="login_pass_input", value="password123")
            if st.button("Sign In", key="login_btn", use_container_width=True):
                if login_email and login_pass:
                    st.session_state["user_authenticated"] = True
                    st.session_state["user_email"] = login_email
                    st.session_state["user_name"] = login_email.split("@")[0].title()
                    st.sidebar.success("Signed in successfully!")
                    st.rerun()
                else:
                    st.sidebar.warning("Please enter email and password.")
                    
        with auth_tab2:
            reg_name = st.text_input("Full Name", key="reg_name_input", value="Candidate User")
            reg_email = st.text_input("Email", key="reg_email_input", value="candidate@example.com")
            reg_pass = st.text_input("Password", type="password", key="reg_pass_input", value="password123")
            if st.button("Create Account", key="reg_btn", use_container_width=True):
                if reg_email and reg_pass:
                    st.session_state["user_authenticated"] = True
                    st.session_state["user_email"] = reg_email
                    st.session_state["user_name"] = reg_name if reg_name else reg_email.split("@")[0].title()
                    st.sidebar.success("Account created!")
                    st.rerun()
                else:
                    st.sidebar.warning("Please fill in registration details.")
