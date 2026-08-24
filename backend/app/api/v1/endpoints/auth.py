from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.dependencies import get_current_active_user, get_db
from app.models.user import User
from app.schemas.token import RefreshTokenRequest, Token
from app.schemas.user import MessageResponse, UserCreate, UserRead
from app.services.auth_service import AuthService

router = APIRouter()


@router.post("/register", response_model=Token, status_code=status.HTTP_201_CREATED)
async def register(
    user_in: UserCreate,
    db: AsyncSession = Depends(get_db)
):
    """Register a new user and return JWT access and refresh tokens."""
    service = AuthService(db)
    return await service.register(user_in)


@router.post("/login", response_model=Token)
async def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: AsyncSession = Depends(get_db)
):
    """OAuth2 compatible login endpoint."""
    service = AuthService(db)
    return await service.login(email=form_data.username, password=form_data.password)


@router.post("/login/json", response_model=Token)
async def login_json(
    credentials: UserCreate,
    db: AsyncSession = Depends(get_db)
):
    """JSON body login endpoint for mobile apps."""
    service = AuthService(db)
    return await service.login(email=credentials.email, password=credentials.password)


@router.post("/refresh", response_model=Token)
async def refresh_token(
    refresh_in: RefreshTokenRequest,
    db: AsyncSession = Depends(get_db)
):
    """Refresh access token using valid refresh token."""
    service = AuthService(db)
    return await service.refresh_token(refresh_in.refresh_token)


@router.post("/logout", response_model=MessageResponse)
async def logout(
    refresh_in: RefreshTokenRequest,
    db: AsyncSession = Depends(get_db)
):
    """Logout by revoking the refresh token."""
    service = AuthService(db)
    await service.logout(refresh_in.refresh_token)
    return MessageResponse(message="Successfully logged out.")


@router.get("/me", response_model=UserRead)
async def read_users_me(
    current_user: User = Depends(get_current_active_user)
):
    """Get current authenticated user profile."""
    return current_user
