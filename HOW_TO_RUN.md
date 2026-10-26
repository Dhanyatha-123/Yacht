# How to Run in VS Code

## Backend (Python FastAPI)

**IMPORTANT: Always use the virtual environment!**

### Option 1: Activate venv first (Recommended)
1. Open terminal in VS Code
2. Activate virtual environment:
   - **Windows:**
     ```
     venv\Scripts\activate
     ```
   - **Mac/Linux:**
     ```
     source venv/bin/activate
     ```
3. Run backend:
   ```
   python main.py
   ```

### Option 2: Use venv Python directly
- **Windows:**
  ```
  venv\Scripts\python.exe main.py
  ```
- **Mac/Linux:**
  ```
  venv/bin/python main.py
  ```

Backend runs on: `http://localhost:8000` or `http://127.0.0.1:8000`

**Important:** Use `localhost:8000` or `127.0.0.1:8000` in your browser, NOT `0.0.0.0:8000`

**Note:** If you see import errors, make sure you're using the venv Python, not system Python!

## Frontend (React)

1. Open new terminal in VS Code
2. Navigate to frontend:
   ```
   cd frontend
   ```
3. Install dependencies (first time only):
   ```
   npm install
   ```
4. Run frontend:
   ```
   npm run dev
   ```
   Frontend runs on: `http://localhost:5173`

## Database

Make sure PostgreSQL is running and database is set up before starting backend.
