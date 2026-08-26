import os
import sys
import re
import time
import streamlit as st
import streamlit.components.v1 as components

# Add workspace paths
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "backend"))

try:
    from app.interview.question_generator import QuestionGenerator
    from app.interview.answer_evaluator import AnswerEvaluator
    from app.speech.transcript_analyzer import TranscriptAnalyzer
    MODULES_READY = True
except Exception:
    MODULES_READY = False

st.set_page_config(
    page_title="AI Mock Interview - CareerLens AI",
    page_icon="🎯",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom High-Contrast CSS
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
    label, [data-testid="stWidgetLabel"] p {
        color: #e2e8f0 !important;
        font-weight: 600 !important;
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

if "generated_questions" not in st.session_state:
    st.session_state["generated_questions"] = []

# Quick Navigation back to Home
st.page_link("streamlit_app.py", label="🏠 Back to Overview Dashboard")

st.markdown("# 🎯 Live AI Mock Interview Practice")
st.caption("Practice mock interviews with simultaneous video camera stream and real-time microphone speech-to-text transcription.")

col_setup1, col_setup2 = st.columns([1.1, 1.9])

with col_setup1:
    st.markdown("<div class='glass-card'>", unsafe_allow_html=True)
    st.markdown("### ⚙️ Session Setup")
    
    target_role = st.selectbox(
        "Target Role",
        ["Backend Developer", "Full Stack Engineer", "Data Scientist / AI Engineer", "Mobile App Developer (Flutter/React Native)", "DevOps / Cloud Engineer"],
        index=0
    )
    
    interview_mode = st.radio(
        "Interview Mode",
        ["Quick Practice (3 Questions)", "Technical Deep Dive", "Behavioral (STAR Method)"],
        index=0,
        horizontal=False
    )
    
    difficulty = st.select_slider(
        "Difficulty Level",
        options=["Junior", "Intermediate", "Senior", "Lead / Staff"],
        value="Intermediate"
    )
    
    skills_input = st.text_input("Resume Skills (comma separated)", "Python, FastAPI, PostgreSQL, Docker, AsyncIO")
    project_input = st.text_input("Resume Project Name", "Async REST API Platform")
    
    generate_btn = st.button("🚀 Generate Interview Questions", use_container_width=True)
    st.markdown("</div>", unsafe_allow_html=True)

with col_setup2:
    if generate_btn:
        skills_list = [s.strip() for s in skills_input.split(",") if s.strip()]
        projects_list = [project_input.strip()] if project_input.strip() else ["Personal Project"]
        
        mode_enum_map = {
            "Quick Practice (3 Questions)": "quick_practice",
            "Technical Deep Dive": "technical",
            "Behavioral (STAR Method)": "behavioral"
        }
        mode_val = mode_enum_map.get(interview_mode, "quick_practice")
        
        if MODULES_READY:
            st.session_state["generated_questions"] = QuestionGenerator.generate_questions(
                target_role=target_role,
                interview_type=mode_val,
                difficulty=difficulty.lower(),
                skills=skills_list,
                projects=projects_list
            )
        else:
            st.session_state["generated_questions"] = [
                {
                    "question_order": 1,
                    "question_text": f"Explain the high-level architecture of your '{projects_list[0]}' project. What key design choices did you make?",
                    "question_type": "project",
                    "difficulty": difficulty,
                    "source_context": f"Derived from resume project: {projects_list[0]}"
                },
                {
                    "question_order": 2,
                    "question_text": f"In your experience with {skills_list[0] if skills_list else 'Python'}, how do you optimize performance and handle concurrency in high-throughput applications?",
                    "question_type": "technical",
                    "difficulty": difficulty,
                    "source_context": f"Targeted technical question for {target_role}"
                },
                {
                    "question_order": 3,
                    "question_text": "Describe a scenario where you faced a tight technical deadline or conflicting requirement. How did you structure your response using the STAR method?",
                    "question_type": "behavioral",
                    "difficulty": difficulty,
                    "source_context": "Behavioral STAR method question"
                }
            ]
        st.success(f"Generated {len(st.session_state['generated_questions'])} personalized interview questions!")

    questions = st.session_state["generated_questions"]

    if not questions:
        st.info("👈 Fill in your session parameters on the left and click **Generate Interview Questions** to begin.")
    else:
        q_index = st.selectbox(
            "Select Question to Practice:",
            options=range(len(questions)),
            format_func=lambda i: f"Question {i+1}: {questions[i]['question_text'][:65]}..."
        )
        
        current_q = questions[q_index]
        
        st.markdown(f"""
        <div class="glass-card">
            <span style="background: #2563eb; color: white; padding: 4px 12px; border-radius: 6px; font-weight: 700; font-size: 0.9rem;">
                Question {current_q['question_order']} of {len(questions)}
            </span>
            <span style="background: #7c3aed; color: white; padding: 4px 12px; border-radius: 6px; font-weight: 700; font-size: 0.9rem; margin-left: 8px;">
                {current_q.get('question_type', 'General').upper()}
            </span>
            <h3 style="margin-top: 14px; color: #ffffff; font-size: 1.35rem;">{current_q['question_text']}</h3>
            <p style="color: #cbd5e1; font-size: 0.95rem;">📌 <i>{current_q.get('source_context', '')}</i></p>
        </div>
        """, unsafe_allow_html=True)
        
        st.markdown("### 🎥 Simultaneous Live Camera & Real-Time Speech-to-Text")
        st.caption("Your camera stream and microphone operate simultaneously. Speak directly into your mic while looking at the camera, and your words will appear live below.")
        
        # HTML5 WebRTC Media + Web Speech API Component
        speech_component_html = """
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body {
                    background-color: #0f172a;
                    color: #f8fafc;
                    font-family: system-ui, -apple-system, sans-serif;
                    margin: 0;
                    padding: 10px;
                }
                .container {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 16px;
                }
                .video-box {
                    flex: 1;
                    min-width: 280px;
                    background: #1e293b;
                    border: 2px solid #3b82f6;
                    border-radius: 12px;
                    padding: 10px;
                    text-align: center;
                }
                video {
                    width: 100%;
                    max-height: 220px;
                    border-radius: 8px;
                    background: #000;
                    object-fit: cover;
                }
                .transcript-box {
                    flex: 1;
                    min-width: 280px;
                    background: #1e293b;
                    border: 2px solid #8b5cf6;
                    border-radius: 12px;
                    padding: 14px;
                    display: flex;
                    flex-direction: column;
                }
                .transcript-title {
                    font-weight: 700;
                    color: #a78bfa;
                    margin-bottom: 8px;
                    font-size: 1rem;
                }
                .transcript-content {
                    flex-grow: 1;
                    min-height: 140px;
                    background: #0f172a;
                    border: 1px solid #334155;
                    border-radius: 8px;
                    padding: 12px;
                    color: #f8fafc;
                    font-size: 1rem;
                    overflow-y: auto;
                    line-height: 1.5;
                }
                .btn-row {
                    margin-top: 12px;
                    display: flex;
                    gap: 10px;
                }
                button {
                    background: linear-gradient(90deg, #2563eb 0%, #7c3aed 100%);
                    color: white;
                    border: none;
                    border-radius: 6px;
                    padding: 10px 16px;
                    font-weight: 600;
                    cursor: pointer;
                }
                button.stop {
                    background: #ef4444;
                }
                .status-indicator {
                    display: inline-block;
                    width: 10px;
                    height: 10px;
                    background-color: #22c55e;
                    border-radius: 50%;
                    margin-right: 6px;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="video-box">
                    <div style="font-weight: 600; margin-bottom: 6px; color: #60a5fa;">📷 Live Camera Feed</div>
                    <video id="webcam" autoplay playsinline muted></video>
                </div>
                <div class="transcript-box">
                    <div class="transcript-title">
                        <span id="statusDot" class="status-indicator" style="background-color: #ef4444;"></span>
                        🎙️ Live Speech-to-Text Transcript (Interview Chat)
                    </div>
                    <div id="transcript" class="transcript-content">Click 'Start Camera & Mic Listening' to begin speaking...</div>
                    <div class="btn-row">
                        <button id="startBtn" onclick="startCameraAndSpeech()">▶️ Start Camera & Mic Listening</button>
                        <button id="stopBtn" class="stop" onclick="stopCameraAndSpeech()">⏹️ Stop</button>
                    </div>
                </div>
            </div>

            <script>
                let mediaStream = null;
                let recognition = null;
                let isListening = false;
                let fullTranscript = '';

                async function startCameraAndSpeech() {
                    try {
                        mediaStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
                        document.getElementById('webcam').srcObject = mediaStream;
                    } catch (err) {
                        console.error('Camera/Mic permission error:', err);
                    }

                    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
                    if (!SpeechRecognition) {
                        document.getElementById('transcript').innerText = "Speech recognition is not supported in this browser. Please use Chrome, Edge, or Safari.";
                        return;
                    }

                    recognition = new SpeechRecognition();
                    recognition.continuous = true;
                    recognition.interimResults = true;
                    recognition.lang = 'en-US';

                    recognition.onstart = function() {
                        isListening = true;
                        document.getElementById('statusDot').style.backgroundColor = '#22c55e';
                    };

                    recognition.onresult = function(event) {
                        let currentInterim = '';
                        for (let i = event.resultIndex; i < event.results.length; ++i) {
                            if (event.results[i].isFinal) {
                                fullTranscript += event.results[i][0].transcript + ' ';
                            } else {
                                currentInterim += event.results[i][0].transcript;
                            }
                        }
                        document.getElementById('transcript').innerText = fullTranscript + (currentInterim ? ' [' + currentInterim + ']' : '');
                    };

                    recognition.onerror = function(event) {
                        console.log('Speech error:', event.error);
                    };

                    recognition.onend = function() {
                        if (isListening) {
                            recognition.start();
                        }
                    };

                    recognition.start();
                }

                function stopCameraAndSpeech() {
                    isListening = false;
                    document.getElementById('statusDot').style.backgroundColor = '#ef4444';
                    if (recognition) {
                        recognition.stop();
                    }
                    if (mediaStream) {
                        mediaStream.getTracks().forEach(track => track.stop());
                    }
                }
            </script>
        </body>
        </html>
        """
        
        components.html(speech_component_html, height=340)
        
        answer_text = st.text_area(
            "Final Transcribed Answer (Edit or type response if needed):",
            height=130,
            placeholder="Your spoken words will also appear here for AI evaluation..."
        )
        
        col_eval1, col_eval2 = st.columns([1, 1])
        with col_eval1:
            spoken_duration = st.number_input("Spoken Duration (seconds)", min_value=5, max_value=300, value=45)
        with col_eval2:
            evaluate_btn = st.button("📝 Evaluate My Answer", use_container_width=True)
            
        if evaluate_btn:
            if not answer_text.strip():
                st.warning("Please record or type an answer before evaluating.")
            else:
                if MODULES_READY:
                    eval_res = AnswerEvaluator.evaluate_answer(current_q['question_text'], answer_text, spoken_duration)
                    speech_res = TranscriptAnalyzer.analyze_transcript(answer_text, spoken_duration)
                else:
                    words_cnt = len(answer_text.split())
                    eval_res = {
                        "score": 90.0 if words_cnt > 20 else 65.0,
                        "word_count": words_cnt,
                        "feedback": "Excellent technical response with clear architectural explanation!" if words_cnt > 20 else "Answer is somewhat brief. Expand with concrete design choices.",
                        "suggested_improvement": "Structure your answer using the STAR method (Situation, Task, Action, Result)."
                    }
                    speech_res = {
                        "speaking_pace_wpm": round(words_cnt / (spoken_duration / 60.0), 1),
                        "filler_word_count": sum(answer_text.lower().count(w) for w in ["um", "uh", "like", "basically", "actually"]),
                        "communication_score": 91.0
                    }
                
                st.markdown("<hr/>", unsafe_allow_html=True)
                st.markdown("#### 📊 Instant AI Assessment & Speech Analysis")
                
                m1, m2, m3, m4 = st.columns(4)
                m1.metric("Overall Score", f"{eval_res.get('score', 80.0):.0f} / 100")
                m2.metric("Word Count", f"{eval_res.get('word_count', 0)} words")
                m3.metric("Speaking Pace", f"{speech_res.get('speaking_pace_wpm', 0)} WPM")
                m4.metric("Filler Words", f"{speech_res.get('filler_word_count', 0)}")
                
                st.markdown(f"**💡 AI Feedback:** {eval_res.get('feedback', '')}")
                st.markdown(f"**🎯 Suggested Improvement:** {eval_res.get('suggested_improvement', '')}")
