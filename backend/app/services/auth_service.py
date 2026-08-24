from datetime import datetime, timedelta, timezone
from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.config import settings
from app.core.security import (
    create_access_token,
    create_refresh_token,
    decode_token,
    verify_password,
)
from app.repositories.user_repository import UserRepository
from app.schemas.token import Token
from app.schemas.user import UserCreate, UserRead


class AuthService:
    def __init__(self, db: AsyncSession):
        self.repo = UserRepository(db)

    async def register(self, user_in: UserCreate) -> Token:
        existing_user = await self.repo.get_by_email(user_in.email)
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="A user with this email already exists."
            )

        user = await self.repo.create(
            email=user_in.email,
            password=user_in.password,
            full_name=user_in.full_name
        )

        return await self._generate_token_response(user)

    async def login(self, email: str, password: str) -> Token:
        user = await self.repo.get_by_email(email)
        if not user or not verify_password(password, user.hashed_password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password.",
                headers={"WWW-Authenticate": "Bearer"},
            )

        if not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Inactive user account."
            )

        return await self._generate_token_response(user)

    async def refresh_token(self, refresh_token_str: str) -> Token:
        try:
            payload = decode_token(refresh_token_str)
            if payload.get("type") != "refresh":
                raise ValueError("Token is not a refresh token")
            user_id = payload.get("sub")
        except ValueError as e:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail=f"Invalid refresh token: {str(e)}",
                headers={"WWW-Authenticate": "Bearer"},
            )

        stored_token = await self.repo.get_refresh_token(refresh_token_str)
        if not stored_token or stored_token.revoked:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Refresh token has been revoked or expired.",
                headers={"WWW-Authenticate": "Bearer"},
            )

        user = await self.repo.get_by_id(user_id)
        if not user or not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User inactive or not found.",
            )

        # Revoke old refresh token (refresh token rotation)
        await self.repo.revoke_refresh_token(refresh_token_str)

        return await self._generate_token_response(user)

    async def logout(self, refresh_token_str: str) -> bool:
        return await self.repo.revoke_refresh_token(refresh_token_str)

    async def _generate_token_response(self, user) -> Token:
        access_token = create_access_token(user.id)
        refresh_token = create_refresh_token(user.id)
        expires_at = datetime.now(timezone.utc) + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)

        await self.repo.store_refresh_token(user.id, refresh_token, expires_at)

        return Token(
            access_token=access_token,
            refresh_token=refresh_token,
            token_type="bearer",
            user=UserRead.model_validate(user)
        )
