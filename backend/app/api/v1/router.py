from fastapi import APIRouter
from app.api.v1.endpoints import (
    auth,
    upload,
    transform,
    animate,
    gallery,
    jobs,
    presets,
    users
)

api_router = APIRouter()

# Include all endpoint routers
api_router.include_router(auth.router, prefix="/auth", tags=["authentication"])
api_router.include_router(upload.router, prefix="/upload", tags=["upload"])
api_router.include_router(transform.router, prefix="/transform", tags=["transform"])
api_router.include_router(animate.router, prefix="/animate", tags=["animation"])
api_router.include_router(gallery.router, prefix="/gallery", tags=["gallery"])
api_router.include_router(jobs.router, prefix="/jobs", tags=["jobs"])
api_router.include_router(presets.router, prefix="/presets", tags=["presets"])
api_router.include_router(users.router, prefix="/users", tags=["users"])