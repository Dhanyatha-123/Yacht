# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Backend (FastAPI)
```bash
# Install dependencies
python -m venv venv && source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt

# Start dev server (from project root, venv activated)
uvicorn main:app --reload --host 127.0.0.1 --port 8000

# API docs available at http://localhost:8000/docs
```

### Frontend (React + Vite)
```bash
cd frontend
npm install
npm run dev       # Start dev server at http://localhost:5173
npm run build     # Production build
npm run preview   # Preview production build
npm run lint      # ESLint
```

### Database
```bash
# Windows
cd database && .\setup-db.ps1

# macOS/Linux
cd database && chmod +x setup-db.sh && ./setup-db.sh

# Manual
psql -U postgres -c "CREATE DATABASE yachtx;"
psql -U postgres -d yachtx -f database/schema.sql
psql -U postgres -d yachtx -f database/seed.sql
```

## Environment Variables

**Root `.env`** (backend reads this via Pydantic-settings):
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=yachtx
DB_USER=postgres
DB_PASSWORD=<password>
JWT_SECRET=<secret>
JWT_EXPIRES_IN=7d
JWT_ALGORITHM=HS256
PORT=8000
NODE_ENV=development
ESIGN_ENABLED=false   # E-sign feature (pyhanko). Default off; routes unregister and UI hides when false.
```

**`frontend/.env.local`**:
```
VITE_API_URL=http://localhost:8000/api
```

## Architecture

### Backend

**Entry point:** `main.py` — creates the FastAPI app, registers CORS middleware (allows localhost ports 3000, 5173–5176), mounts `/uploads` for static file serving, and includes all routers.

**Request lifecycle:**
1. Request hits a route in `app/api/<resource>.py`
2. FastAPI injects dependencies via `Depends()` — most routes use `get_db()` and `get_current_user()` from `app/core/dependencies.py`
3. Route handler runs raw SQL via an asyncpg connection from the global pool
4. Response returned as dict (FastAPI serializes it)

**Database access (`app/db/database.py`):**
- Single global asyncpg connection pool (min=1, max=10), initialized at startup
- Use `async with get_db() as conn:` in route handlers to acquire a connection
- All queries are parameterized (`$1`, `$2`, ... placeholders)

**Auth (`app/core/`):**
- `security.py`: bcrypt password hashing, JWT encode/decode (python-jose, HS256)
- `dependencies.py`: `get_current_user()` validates Bearer token and fetches user row; `get_optional_user()` allows unauthenticated access; `require_seller` / `require_admin` are pre-built role guards using `require_role()`

**Config (`app/core/config.py`):**
- Pydantic `BaseSettings` — reads from `.env` file automatically. Import `settings` singleton where needed.

**API routes** (`app/api/`): `auth`, `boats`, `search`, `favorites`, `inquiries`, `contact`, `saved_searches`, `compare`, `price_alerts`, `share`, `admin`, `restricted`, `equipment`, `photos`

**Schemas** (`app/schemas/`): Pydantic v2 models for request/response validation.

**Service layer** (`app/services/`): Minimal — only `audit_log.py` exists. Most business logic lives directly in route handlers.

**File uploads:** Stored in `backend/uploads/`, served at `/uploads`.

### Frontend

**Entry:** `frontend/src/main.jsx` → `frontend/src/App.jsx`

**Routing:** React Router v7 with three route groups:
- Public routes (no auth required)
- `/dashboard/*` — protected, requires authenticated user
- `/admin/*` — protected, requires admin role

**Global state via Context API** (all wrapped at root in `App.jsx`):
- `AuthContext` — user object, login/logout/register, JWT in localStorage
- `NotificationContext` — toast notifications
- `CompareContext` — boats queued for comparison

**API layer (`frontend/src/services/api.js`):**
- Single Axios instance pointed at `VITE_API_URL`
- Request interceptor auto-injects `Authorization: Bearer <token>` from localStorage
- Organized into named objects: `authAPI`, `boatsAPI`, `searchAPI`, `favoritesAPI`, `inquiriesAPI`, `savedSearchesAPI`, `compareAPI`, `priceAlertsAPI`, `shareAPI`, `photosAPI`, `equipmentAPI`, `restrictedAPI`, `contactAPI`

**Theme (`frontend/src/theme.js`):** MUI theme — primary `#1a3a5c` (dark navy), secondary `#e67e22` (orange).

### Database Schema (key tables)
- `users` — auth + profile, roles: `buyer` / `seller` / `admin`
- `boats` — listings with ~50 spec fields
- `boat_images` — multiple images per boat, one flagged as primary
- `boat_specifications` — flexible key-value extra specs
- `inquiries` + `messages` — threaded messaging between buyer and seller
- `favorites`, `saved_searches`, `price_alerts`, `boat_comparisons` — user feature tables

Migration SQL lives in `database/migrations/`; initial schema/seed in `database/schema.sql` and `database/seed.sql`.
Demo conversations for Helm > Messages: `cd database && ./seed_demo_messages.sh` (re-runnable).

Messaging tables: `inquiries` (`kind`: listing / support / outreach; `boat_id` is NULL on support threads) + `messages`,
with `message_photos` for listing photos shared through Send To Buyer and `message_attachments` for files attached to a
reply. Attachment bytes live in `backend/private/`, which is never served statically — downloads go through the API.

## Test Credentials (dev seed data)
| Role   | Email                  | Password |
|--------|------------------------|----------|
| Admin  | admin@yachtx.com       | Test123! |
| Seller | seller@yachtx.com      | Test123! |
| Buyer  | buyer@yachtx.com       | Test123! |
