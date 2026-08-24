# CareerLens AI: An Explainable and Fair Agentic AI System for Personalized Career Intelligence and Job Recommendation

CareerLens AI is a mobile-first closed-loop career intelligence platform that helps students and job seekers build explainable skill profiles, analyze job descriptions, match compatibility with granular evidence, generate personalized career roadmaps, practice adaptive AI mock interviews, and receive grounded RAG-assisted career guidance.

---

## 🏗️ Architecture & Technology Stack

### Mobile Frontend (`mobile/`)
* **Framework**: Flutter & Dart (Material 3)
* **Architecture**: Feature-First Architecture + Clean Architecture + Repository Pattern
* **State Management**: Riverpod (`flutter_riverpod`)
* **Navigation**: GoRouter (`go_router`) with auth guards
* **Network & Security**: Dio with `AuthInterceptor` (automatic refresh token queueing) + `flutter_secure_storage`
* **UI/UX**: Google Fonts (Outfit & Inter), Glassmorphic widgets, smooth animations (`flutter_animate`), responsive dark/light mode

### Backend (`backend/`)
* **Framework**: Python 3.11+ / FastAPI
* **Database**: PostgreSQL with `pgvector` extension (with SQLite async support for local test/dev)
* **ORM & Migrations**: SQLAlchemy 2.x (asyncio) + Alembic
* **Security & Auth**: Dual-JWT Token System (Access Token + Refresh Token Rotation with Revocation), Password Hashing (`bcrypt`)
* **Validation**: Pydantic v2 + Pydantic Settings
* **Testing**: Pytest with `httpx` AsyncClient and in-memory test database

### Infrastructure (`infrastructure/`)
* **Docker Compose**: Containerized setup for PostgreSQL (`ankane/pgvector`) and FastAPI API service

---

## 📂 Complete Monorepo Project Structure

```text
CareerLens AI/
├── mobile/                               # Flutter Mobile Application
│   ├── lib/
│   │   ├── core/
│   │   │   ├── api/
│   │   │   │   ├── api_client.dart       # Dio instance with timeout & logging
│   │   │   │   └── auth_interceptor.dart # Bearer token injection & refresh queue
│   │   │   ├── constants/
│   │   │   │   └── api_constants.dart    # Endpoints & storage keys
│   │   │   ├── services/
│   │   │   │   └── secure_storage_service.dart # Encrypted JWT storage
│   │   │   ├── theme/
│   │   │   │   └── app_theme.dart        # Material 3 Dark/Light themes
│   │   │   └── widgets/
│   │   │       └── custom_widgets.dart   # PrimaryButton, GlassCard, CustomTextField
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   │   ├── data/auth_repository.dart
│   │   │   │   ├── domain/models/
│   │   │   │   │   ├── user_model.dart
│   │   │   │   │   └── auth_tokens.dart
│   │   │   │   ├── presentation/screens/
│   │   │   │   │   ├── splash_screen.dart
│   │   │   │   │   ├── login_screen.dart
│   │   │   │   │   └── register_screen.dart
│   │   │   │   └── providers/auth_provider.dart # Riverpod AuthNotifier
│   │   │   └── dashboard/
│   │   │       └── presentation/screens/
│   │   │           └── placeholder_dashboard.dart
│   │   ├── routes/
│   │   │   └── app_router.dart          # GoRouter auth redirection guards
│   │   └── main.dart                    # Application entrypoint
│   └── pubspec.yaml
│
├── backend/                              # Python FastAPI Backend
│   ├── app/
│   │   ├── api/
│   │   │   └── v1/
│   │   │       ├── endpoints/
│   │   │       │   └── auth.py          # /register, /login, /refresh, /logout, /me
│   │   │       └── router.py            # API V1 router aggregation
│   │   ├── core/
│   │   │   ├── config.py                # Pydantic BaseSettings
│   │   │   ├── security.py              # Password hashing & JWT sign/verify
│   │   │   └── dependencies.py          # DB session & OAuth2 dependencies
│   │   ├── database/
│   │   │   ├── base.py                  # SQLAlchemy DeclarativeBase
│   │   │   └── session.py               # Async engine & sessionmaker
│   │   ├── models/
│   │   │   └── user.py                  # User & RefreshToken SQLAlchemy models
│   │   ├── schemas/
│   │   │   ├── user.py                  # UserCreate, UserRead schemas
│   │   │   └── token.py                 # Token & RefreshTokenRequest schemas
│   │   ├── repositories/
│   │   │   └── user_repository.py       # Data access layer
│   │   ├── services/
│   │   │   └── auth_service.py          # Authentication business logic
│   │   └── main.py                      # FastAPI app, CORS, error handling
│   ├── tests/
│   │   ├── conftest.py                  # Async DB & HTTP client fixtures
│   │   └── test_auth.py                 # Pytest authentication test suite
│   ├── Dockerfile                       # Multi-stage Python build
│   ├── pytest.ini
│   └── requirements.txt
│
├── infrastructure/
│   └── docker/
│       └── postgres_init.sql            # Enabling pgvector extension
│
├── .env.example                         # Environment configuration template
├── docker-compose.yml                   # PostgreSQL (pgvector) + FastAPI backend
└── README.md                            # Documentation
```

---

## ⚡ Environment Variables (`.env.example`)

Copy `.env.example` to `.env`:

```env
PROJECT_NAME="CareerLens AI"
ENVIRONMENT="development"
DEBUG=True
API_V1_STR="/api/v1"

# Database Configuration
DATABASE_URL="sqlite+aiosqlite:///./careerlens.db"
# PostgreSQL in Docker:
# DATABASE_URL="postgresql+asyncpg://careerlens:careerlens_pass@localhost:5432/careerlens_db"

POSTGRES_SERVER=localhost
POSTGRES_USER=careerlens
POSTGRES_PASSWORD=careerlens_pass
POSTGRES_DB=careerlens_db
POSTGRES_PORT=5432

# Security & Authentication
JWT_SECRET="careerlens_ai_super_secret_jwt_key_change_in_production_32chars_min"
JWT_ALGORITHM="HS256"
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# CORS
BACKEND_CORS_ORIGINS=["http://localhost:3000","http://localhost:8000","*"]
```

---

## 🚀 Running the Project

### Option A: Local Development (FastAPI + SQLite/Postgres)

1. **Backend Setup**:
   ```bash
   cd backend
   python -m venv venv
   # On Windows:
   .\venv\Scripts\activate
   # On Linux/macOS:
   source venv/bin/activate

   pip install -r requirements.txt
   ```

2. **Run Backend Server**:
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```
   * OpenAPI Documentation: [http://localhost:8000/docs](http://localhost:8000/docs)
   * Health Check: [http://localhost:8000/health](http://localhost:8000/health)

3. **Run Backend Pytest Suite**:
   ```bash
   pytest tests/
   ```

4. **Flutter Mobile Setup & Run**:
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```

---

### Option B: Docker Compose (Full Stack with PostgreSQL + pgvector)

```bash
docker-compose up --build -d
```

---

## 🔐 API Endpoint Summary & JWT Authentication Flow

### Auth API Summary

| Method | Endpoint | Description | Auth Required |
| :--- | :--- | :--- | :--- |
| `GET` | `/health` | Application health check | ❌ |
| `POST` | `/api/v1/auth/register` | Register user & receive JWT access + refresh tokens | ❌ |
| `POST` | `/api/v1/auth/login` | Form login (OAuth2 standard) | ❌ |
| `POST` | `/api/v1/auth/login/json` | JSON body login for mobile clients | ❌ |
| `POST` | `/api/v1/auth/refresh` | Exchange refresh token for new access & refresh tokens | ❌ |
| `POST` | `/api/v1/auth/logout` | Revoke current refresh token | ❌ |
| `GET` | `/api/v1/auth/me` | Fetch current authenticated user profile | ✅ Bearer |

---

### JWT Authentication & Security Flow

```text
┌──────────────┐                 ┌──────────────┐                 ┌──────────────┐
│ Flutter App  │                 │ FastAPI API  │                 │  PostgreSQL  │
└──────┬───────┘                 └──────┬───────┘                 └──────┬───────┘
       │                                │                                │
       │ 1. POST /auth/register or /login                                │
       ├───────────────────────────────>│                                │
       │                                │ 2. Verify Credentials & Hash   │
       │                                ├───────────────────────────────>│
       │                                │ 3. Generate Access + Refresh   │
       │ 4. Tokens + User JSON          │                                │
       │<───────────────────────────────┤                                │
       │                                │                                │
       │ 5. Store Tokens in             │                                │
       │    flutter_secure_storage      │                                │
       │                                │                                │
       │ 6. Request with Authorization: │                                │
       │    Bearer <access_token>       │                                │
       ├───────────────────────────────>│                                │
       │                                │ 7. Decode JWT & Verify Expiry  │
       │ 8. Protected Resource Data     │                                │
       │<───────────────────────────────┤                                │
       │                                │                                │
       │ 9. [Token Expired 401 Error]   │                                │
       │    Dio Interceptor Intercepts  │                                │
       │                                │                                │
       │ 10. POST /auth/refresh         │                                │
       ├───────────────────────────────>│ 11. Revoke Old Refresh Token   │
       │                                │     Store New Refresh Token    │
       │ 12. New Tokens Returned        │                                │
       │<───────────────────────────────┤                                │
       │                                │                                │
       │ 13. Retry Original Request     │                                │
       ├───────────────────────────────>│                                │
```

---

## ⏭️ Phase 2 Roadmap Overview

With Phase 1 Foundation established, Phase 2 will introduce:
1. **Onboarding Feature (`features/onboarding`)**: Multi-step candidate goal selection, current role, target role, weekly learning hours, and initial skill checklist.
2. **User Profile System (`features/profile`)**: Career goal models, target role management, and database migrations for user profile tables.
3. **Backend Onboarding Endpoints (`/api/v1/profile`)**: Storing candidate preferences and onboarding state in PostgreSQL.
