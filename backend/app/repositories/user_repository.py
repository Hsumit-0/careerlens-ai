from datetime import datetime
from typing import Optional
from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.user import RefreshToken, User
from app.core.security import get_password_hash


class UserRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_by_id(self, user_id: str) -> Optional[User]:
        result = await self.db.execute(select(User).where(User.id == user_id))
        return result.scalars().first()

    async def get_by_email(self, email: str) -> Optional[User]:
        result = await self.db.execute(select(User).where(User.email == email))
        return result.scalars().first()

    async def create(self, email: str, password: str, full_name: str) -> User:
        hashed_password = get_password_hash(password)
        user = User(
            email=email,
            hashed_password=hashed_password,
            full_name=full_name
        )
        self.db.add(user)
        await self.db.flush()
        await self.db.refresh(user)
        return user

    async def store_refresh_token(self, user_id: str, token: str, expires_at: datetime) -> RefreshToken:
        refresh_token_obj = RefreshToken(
            user_id=user_id,
            token=token,
            expires_at=expires_at
        )
        self.db.add(refresh_token_obj)
        await self.db.flush()
        return refresh_token_obj

    async def get_refresh_token(self, token: str) -> Optional[RefreshToken]:
        result = await self.db.execute(
            select(RefreshToken).where(RefreshToken.token == token, RefreshToken.revoked == False)
        )
        return result.scalars().first()

    async def revoke_refresh_token(self, token: str) -> bool:
        stmt = (
            update(RefreshToken)
            .where(RefreshToken.token == token)
            .values(revoked=True)
        )
        result = await self.db.execute(stmt)
        return result.rowcount > 0

    async def revoke_all_user_tokens(self, user_id: str) -> int:
        stmt = (
            update(RefreshToken)
            .where(RefreshToken.user_id == user_id)
            .values(revoked=True)
        )
        result = await self.db.execute(stmt)
        return result.rowcount
