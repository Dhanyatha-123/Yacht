from fastapi import FastAPI, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse
import asyncio
import os
from dotenv import load_dotenv

from app.core.config import settings
from app.db.database import check_db_connection
from app.api import auth, boats, search, favorites, inquiries, contact, saved_searches, compare, price_alerts, share, admin, restricted, equipment, photos, videos, documents, notifications, search_click, search_analytics, manufacturers, esign, listing_agreements, sample_models, listing_analytics
from app.services.search_analytics_cleanup import run_cleanup_loop
from app.services.saved_search_alerts import run_alert_loop

load_dotenv()

app = FastAPI(
    title="YachtX API",
    version="1.0.0",
    description="YachtX Backend API - Boat Marketplace"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Serve static files from uploads directory
if os.path.exists("backend/uploads"):
    app.mount("/uploads", StaticFiles(directory="backend/uploads"), name="uploads")

# The image editor draws /uploads photos onto a canvas, which needs CORS
# approval even when the response comes from the browser cache. Static photos
# are public, so expose them to any origin unconditionally (CORSMiddleware
# only adds headers when a request carries Origin, which plain <img> loads
# don't — their cached responses would otherwise poison later canvas loads).
@app.middleware("http")
async def uploads_cors(request: Request, call_next):
    response = await call_next(request)
    if request.url.path.startswith("/uploads/"):
        response.headers["Access-Control-Allow-Origin"] = "*"
    return response

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(boats.router, prefix="/api/boats", tags=["boats"])
app.include_router(search.router, prefix="/api/search", tags=["search"])
app.include_router(favorites.router, prefix="/api/favorites", tags=["favorites"])
app.include_router(inquiries.router, prefix="/api/inquiries", tags=["inquiries"])
app.include_router(contact.router, prefix="/api/contact", tags=["contact"])
app.include_router(saved_searches.router, prefix="/api/saved-searches", tags=["saved-searches"])
app.include_router(compare.router, prefix="/api/compare", tags=["compare"])
app.include_router(price_alerts.router, prefix="/api/price-alerts", tags=["price-alerts"])
app.include_router(share.router, prefix="/api/share", tags=["share"])
app.include_router(admin.router, prefix="/api/admin", tags=["admin"])
app.include_router(restricted.router, prefix="/api/boats", tags=["restricted"])
app.include_router(equipment.router, prefix="/api/boats", tags=["equipment"])
app.include_router(photos.router, prefix="/api/boats", tags=["photos"])
app.include_router(videos.router, prefix="/api/boats", tags=["videos"])
app.include_router(documents.router, prefix="/api/boats", tags=["documents"])
app.include_router(notifications.router, prefix="/api/notifications", tags=["notifications"])
app.include_router(search_click.router, prefix="/api/search", tags=["search"])
app.include_router(search_analytics.router, prefix="/api/admin", tags=["admin"])
app.include_router(manufacturers.router, prefix="/api/manufacturers", tags=["manufacturers"])
app.include_router(listing_analytics.router, prefix="/api/listing-analytics", tags=["listing-analytics"])
# TEMPORARY demo catalogue (migration 024) - remove with the sample_models table.
app.include_router(sample_models.router, prefix="/api/sample-models", tags=["sample-models"])

# E-sign routes are registered only when the feature is enabled (default off).
if settings.ESIGN_ENABLED:
    app.include_router(esign.router, prefix="/api/esign", tags=["esign"])
    app.include_router(
        listing_agreements.router, prefix="/api/listing-agreements", tags=["listing-agreements"]
    )

@app.on_event("startup")
async def start_cleanup_task():
    asyncio.create_task(run_cleanup_loop())
    if settings.SAVED_SEARCH_ALERTS_ENABLED:
        asyncio.create_task(run_alert_loop())


@app.get("/api/health")
async def health_check():
    try:
        await check_db_connection()
        return {
            "status": "ok",
            "message": "YachtX API is running",
            "timestamp": __import__("datetime").datetime.now().isoformat()
        }
    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "message": "Database connection failed"
            }
        )

@app.get("/")
async def root():
    return {
        "message": "🚢 Welcome to YachtX API",
        "version": "1.0.0",
        "endpoints": {
            "health": "/api/health",
            "auth": "/api/auth",
            "boats": "/api/boats",
            "search": "/api/search",
            "favorites": "/api/favorites",
            "inquiries": "/api/inquiries",
            "contact": "/api/contact",
            "savedSearches": "/api/saved-searches",
            "compare": "/api/compare",
            "priceAlerts": "/api/price-alerts",
            "share": "/api/share",
            "admin": "/api/admin"
        }
    }

@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    """Handle HTTP exceptions with proper format"""
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.detail} if isinstance(exc.detail, dict) else {"detail": {"message": str(exc.detail)}}
    )

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Handle all other exceptions"""
    import traceback
    error_detail = {"message": str(exc) if str(exc) else "Internal Server Error"}
    if settings.NODE_ENV == "development":
        error_detail["stack"] = traceback.format_exc()
    return JSONResponse(
        status_code=500,
        content={"error": error_detail}
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=int(os.getenv("PORT", 5000)), reload=True)
