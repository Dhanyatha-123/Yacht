# YachtX - Setup & Run Guide

## Prerequisites

### Windows
- Python 3.10+ ([Download](https://www.python.org/downloads/))
- Node.js 18+ ([Download](https://nodejs.org/))
- PostgreSQL 14+ ([Download](https://www.postgresql.org/download/windows/))
- Git for Windows

### macOS
- Python 3.10+ (`brew install python@3.10` or [Download](https://www.python.org/downloads/))
- Node.js 18+ (`brew install node` or [Download](https://nodejs.org/))
- PostgreSQL 14+ (`brew install postgresql@14` or [Download](https://www.postgresql.org/download/macosx/))
- Git (`brew install git`)

## Setup

### 1. Database Setup

#### Windows
```powershell
# Navigate to database folder
cd database

# Run setup script (will prompt for PostgreSQL password)
.\setup-db.ps1

# Or manually:
psql -U postgres -c "CREATE DATABASE yachtx;"
psql -U postgres -d yachtx -f schema.sql
psql -U postgres -d yachtx -f seed.sql
```

#### macOS
```bash
# Navigate to database folder
cd database

# Make script executable
chmod +x setup-db.sh

# Run setup script (will prompt for PostgreSQL password)
./setup-db.sh

# Or manually:
psql -U postgres -c "CREATE DATABASE yachtx;"
psql -U postgres -d yachtx -f schema.sql
psql -U postgres -d yachtx -f seed.sql
```

#### Migrations

`schema.sql` builds the current schema from scratch. An existing database is
brought up to date by applying the files in `database/migrations/` in order.

#### Demo conversations (Helm > Messages)

Two ten-message threads — one under With Buyers with listing photos shared into
it, one under With Sellers with a file attached — so Messages has something to
show on a fresh machine. Safe to run more than once.

```bash
cd database && ./seed_demo_messages.sh
```

### 2. Backend Setup

#### Windows
```powershell
# Create virtual environment
python -m venv venv

# Activate virtual environment
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

#### macOS
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### 3. Frontend Setup

#### Windows & macOS (Same)
```bash
cd frontend
npm install
```

### 4. Environment Configuration

Create `.env` file in project root:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=yachtx
DB_USER=postgres
DB_PASSWORD=412365

# Server
PORT=8000
JWT_SECRET=your-secret-key-change-in-production

# CORS
CORS_ORIGINS=http://localhost:5173
```

Create `frontend/.env` file:

```env
VITE_API_URL=http://localhost:8000/api
VITE_APP_NAME=YachtX
```

## Run

### Backend (Terminal 1)

#### Windows
```powershell
venv\Scripts\activate
uvicorn main:app --reload --host 127.0.0.1 --port 8000
```

#### macOS
```bash
source venv/bin/activate
uvicorn main:app --reload --host 127.0.0.1 --port 8000
```

**Endpoints:**
- API: http://localhost:8000
- Docs: http://localhost:8000/docs
- Health: http://localhost:8000/api/health

### Frontend (Terminal 2)

#### Windows & macOS (Same)
```bash
cd frontend
npm run dev
```

**URL:** http://localhost:5173

## Test Credentials

**All users use the same password: `Test123!`**

### Admin Accounts
```
admin@yachtx.com / Test123!
admin2@yachtx.com / Test123!
```

### Seller Accounts
```
seller@yachtx.com / Test123!
seller2@yachtx.com / Test123!
seller3@yachtx.com / Test123!
seller4@yachtx.com / Test123!
seller5@yachtx.com / Test123!
```

### Buyer Accounts
```
buyer@yachtx.com / Test123!
buyer2@yachtx.com / Test123!
buyer3@yachtx.com / Test123!
buyer4@yachtx.com / Test123!
```

### Test Account
```
test@yachtx.com / Test123!
```

## Troubleshooting

### Windows
- **PostgreSQL not found**: Add `C:\Program Files\PostgreSQL\14\bin` to PATH
- **Python not found**: Ensure Python is in PATH or use full path
- **Permission denied**: Run PowerShell as Administrator if needed

### macOS
- **PostgreSQL service not running**: `brew services start postgresql@14`
- **Python version**: Use `python3` instead of `python`
- **Permission denied**: `chmod +x` on scripts

## Notes

- Default database password: `412365` (change in production)
- Backend runs on port `8000`
- Frontend runs on port `5173` (Vite default)
- Virtual environment must be activated before running backend
