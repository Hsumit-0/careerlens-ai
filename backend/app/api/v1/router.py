from fastapi import APIRouter
from app.api.v1.endpoints import auth, interview

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=["Authentication"])
api_router.include_router(interview.router, prefix="/interviews", tags=["AI Interview Studio"])
