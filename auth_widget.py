import streamlit as st

def render_sidebar_auth():
    """Renders sleek Login / Register / Logout user authentication widget in the sidebar."""
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
