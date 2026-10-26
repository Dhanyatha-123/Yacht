# YachtX Project Structure - Technical Documentation

**Author:** Senior Engineering Team  
**Last Updated:** February 2026  
**Version:** 1.0.0

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Technology Stack](#technology-stack)
4. [Directory Structure](#directory-structure)
5. [Backend Architecture](#backend-architecture)
6. [Frontend Architecture](#frontend-architecture)
7. [Database Schema](#database-schema)
8. [Key Files and Components](#key-files-and-components)
9. [Development Workflow](#development-workflow)

---

## Project Overview

YachtX is a full-stack yacht marketplace platform built with modern web technologies. The project follows a **monorepo structure** with separate backend and frontend applications, sharing a common database layer.

### Core Functionality

- **User Management**: Registration, authentication, profile management
- **Boat Listings**: CRUD operations for yacht listings with image management
- **Search & Discovery**: Advanced search with filters, saved searches, price alerts
- **User Interactions**: Favorites, inquiries, boat comparisons, sharing
- **Admin Dashboard**: Comprehensive admin panel for platform management
- **Audit Logging**: Complete audit trail for administrative actions

---

## Architecture

### High-Level Architecture

```
┌─────────────────┐
│   React Frontend │  (Port 5173)
│   (Vite + MUI)   │
└────────┬─────────┘
         │ HTTP/REST API
         │ (CORS enabled)
┌────────▼─────────┐
│  FastAPI Backend │  (Port 8000)
│   (Python 3.10)  │
└────────┬─────────┘
         │ asyncpg
         │
┌────────▼─────────┐
│  PostgreSQL DB   │
│   (Port 5432)    │
└──────────────────┘
```

### Design Patterns

- **RESTful API**: All backend endpoints follow REST conventions
- **MVC Pattern**: Frontend follows component-based MVC (React)
- **Repository Pattern**: Database access abstracted through connection pool
- **Dependency Injection**: FastAPI's dependency system for auth and DB access
- **Context API**: React Context for global state management

---

## Technology Stack

### Backend

| Technology | Version | Purpose |
|------------|---------|---------|
| Python | 3.10.11 | Runtime environment |
| FastAPI | 0.109.0 | Web framework |
| Uvicorn | 0.27.0 | ASGI server |
| asyncpg | 0.29.0 | PostgreSQL async driver |
| Pydantic | 2.5.3 | Data validation & settings |
| python-jose | 3.3.0 | JWT token handling |
| passlib | 1.7.4 | Password hashing (bcrypt) |
| python-dotenv | 1.0.0 | Environment configuration |

### Frontend

| Technology | Version | Purpose |
|------------|---------|---------|
| React | 19.2.0 | UI framework |
| Vite | 7.2.4 | Build tool & dev server |
| Material-UI | 7.3.6 | Component library |
| React Router | 7.11.0 | Client-side routing |
| Axios | 1.13.2 | HTTP client |
| Recharts | 3.6.0 | Data visualization |

### Database

- **PostgreSQL**: Relational database
- **Schema Versioning**: Migration scripts in `database/migrations/`

---

## Directory Structure

```
yachtx-rebuild/
├── app/                      # Backend Python application
│   ├── api/                  # API route handlers
│   ├── core/                 # Core configuration & utilities
│   ├── db/                   # Database connection & pool
│   ├── schemas/               # Pydantic data models
│   └── services/             # Business logic services
│
├── frontend/                  # React frontend application
│   ├── src/
│   │   ├── components/       # Reusable UI components
│   │   ├── pages/            # Route pages
│   │   ├── context/          # React Context providers
│   │   ├── services/         # API service layer
│   │   └── utils/           # Utility functions
│   ├── public/               # Static assets
│   └── dist/                  # Production build output
│
├── backend/                   # Legacy Node.js backend (deprecated)
│   └── src/                   # Node.js routes & controllers
│
├── database/                  # Database scripts
│   ├── schema.sql            # Main database schema
│   ├── migrations/           # Database migrations
│   ├── seed.sql              # Seed data
│   └── setup-db.*            # Setup scripts
│
├── venv/                      # Python virtual environment
├── main.py                    # FastAPI application entry point
├── requirements.txt           # Python dependencies
└── HOW_TO_RUN.md             # Setup instructions
```

---

## Backend Architecture

### Application Entry Point

**`main.py`**
- FastAPI application initialization
- CORS middleware configuration
- Router registration for all API endpoints
- Global exception handlers
- Static file serving for uploads
- Health check endpoint (`/api/health`)
- Root endpoint with API documentation

**Key Responsibilities:**
- Application lifecycle management
- Middleware configuration
- Route aggregation
- Error handling strategy

### Core Module (`app/core/`)

#### `config.py`
- **Purpose**: Centralized configuration management using Pydantic Settings
- **Contains**:
  - Database connection parameters (host, port, name, user, password)
  - JWT configuration (secret, expiration, algorithm)
  - Server settings (port, environment)
  - CORS allowed origins
- **Environment Variables**: Loads from `.env` file via `python-dotenv`

#### `security.py`
- **Purpose**: Authentication and authorization utilities
- **Functions**:
  - `get_password_hash()`: Bcrypt password hashing
  - `verify_password()`: Password verification
  - `create_access_token()`: JWT token generation
  - `decode_access_token()`: JWT token validation
- **Security**: Uses `passlib[bcrypt]` for password hashing, `python-jose` for JWT

#### `dependencies.py`
- **Purpose**: FastAPI dependency injection for common operations
- **Dependencies**:
  - `get_current_user()`: Validates JWT and returns authenticated user
  - `get_optional_user()`: Returns user if authenticated, None otherwise
  - `require_seller()`: Ensures user has seller role
  - `require_admin()`: Ensures user has admin role
- **Pattern**: Uses FastAPI's `Depends()` for dependency injection

### Database Module (`app/db/`)

#### `database.py`
- **Purpose**: Database connection pool management
- **Key Components**:
  - `get_pool()`: Creates asyncpg connection pool (singleton pattern)
  - `get_db()`: Context manager for database connections
  - `check_db_connection()`: Health check for database connectivity
- **Connection Pool**: Configured with min_size=1, max_size=10
- **Error Handling**: Comprehensive error handling for connection failures

### API Routes (`app/api/`)

All route handlers follow FastAPI's APIRouter pattern with consistent structure:

#### `auth.py`
- **Endpoints**:
  - `POST /api/auth/register`: User registration
  - `POST /api/auth/login`: User authentication
  - `GET /api/auth/me`: Get current user profile
  - `PUT /api/auth/profile`: Update user profile
  - `POST /api/auth/change-password`: Change password
- **Security**: Password hashing, JWT token generation

#### `boats.py`
- **Endpoints**:
  - `GET /api/boats/`: List boats with pagination and filters
  - `GET /api/boats/{id}`: Get boat details
  - `POST /api/boats/`: Create new boat listing (seller only)
  - `PUT /api/boats/{id}`: Update boat listing (owner only)
  - `DELETE /api/boats/{id}`: Delete boat listing (owner only)
- **Features**: Image upload support, status management, owner verification

#### `search.py`
- **Endpoints**:
  - `GET /api/search/`: Advanced search with multiple filters
- **Filters**: Manufacturer, type, price range, year, length, location
- **Performance**: Optimized queries with proper indexing

#### `favorites.py`
- **Endpoints**:
  - `GET /api/favorites/`: Get user's favorite boats
  - `POST /api/favorites/`: Add boat to favorites
  - `DELETE /api/favorites/{boat_id}`: Remove from favorites
- **Authentication**: Requires authenticated user

#### `inquiries.py`
- **Endpoints**:
  - `GET /api/inquiries/`: Get user's inquiries
  - `POST /api/inquiries/`: Create new inquiry
  - `PUT /api/inquiries/{id}`: Update inquiry status
- **Features**: Inquiry status tracking, email notifications

#### `contact.py`
- **Endpoints**:
  - `POST /api/contact/`: Submit contact form
- **Purpose**: General contact form submissions

#### `saved_searches.py`
- **Endpoints**:
  - `GET /api/saved-searches/`: Get user's saved searches
  - `POST /api/saved-searches/`: Save search criteria
  - `DELETE /api/saved-searches/{id}`: Delete saved search
- **Features**: Search criteria persistence, alert notifications

#### `compare.py`
- **Endpoints**:
  - `GET /api/compare/`: Get comparison data for boats
  - `POST /api/compare/`: Add boat to comparison
- **Features**: Side-by-side boat comparison

#### `price_alerts.py`
- **Endpoints**:
  - `GET /api/price-alerts/`: Get user's price alerts
  - `POST /api/price-alerts/`: Create price alert
  - `DELETE /api/price-alerts/{id}`: Delete price alert
- **Features**: Price change notifications

#### `share.py`
- **Endpoints**:
  - `POST /api/share/`: Share boat listing
- **Features**: Email sharing, social media integration

#### `admin.py`
- **Endpoints**:
  - `GET /api/admin/dashboard`: Admin dashboard statistics
  - `GET /api/admin/users`: User management
  - `GET /api/admin/boats`: Boat listing management
  - `GET /api/admin/inquiries`: Inquiry management
  - `GET /api/admin/contacts`: Contact submissions
  - `GET /api/admin/audit-logs`: Audit log viewing
- **Security**: Admin-only access, comprehensive audit logging

### Schemas (`app/schemas/`)

Pydantic models for request/response validation:

- **`auth.py`**: `RegisterRequest`, `LoginRequest`, `RegisterResponse`, `LoginResponse`, `UserResponse`
- **`boats.py`**: `BoatCreate`, `BoatUpdate`, `BoatResponse`, `BoatImageCreate`
- **`contact.py`**: `ContactSubmission`
- **`inquiries.py`**: `InquiryCreate`, `InquiryResponse`
- **`search.py`**: `SearchFilters`, `SearchResponse`

**Purpose**: Type safety, automatic validation, OpenAPI schema generation

### Services (`app/services/`)

#### `audit_log.py`
- **Purpose**: Audit logging service for administrative actions
- **Features**: Logs all admin actions with timestamps, user info, and action details
- **Storage**: Stored in `audit_logs` database table

---

## Frontend Architecture

### Application Entry Point

**`frontend/src/main.jsx`**
- React application initialization
- Renders root `App` component
- Uses React 18's `createRoot` API

**`frontend/src/App.jsx`**
- Main application component
- Sets up React Router with all routes
- Wraps app with Context providers (Auth, Notification, Compare)
- Conditionally renders Navbar/Footer based on route
- Includes floating action buttons (Contact, Compare, Quick Actions)

### Routing Structure

**Public Routes:**
- `/` - Homepage
- `/search` - Boat search
- `/boats/:id` - Boat detail page
- `/login` - Login page
- `/register` - Registration page
- `/about`, `/contact`, `/terms`, `/privacy`, `/copyright` - Static pages

**Protected Routes (Dashboard):**
- `/dashboard` - Dashboard home
- `/dashboard/boats` - User's boat listings
- `/dashboard/boats/new` - Create new listing
- `/dashboard/boats/:id/edit` - Edit listing
- `/dashboard/favorites` - Favorite boats
- `/dashboard/inquiries` - User inquiries
- `/dashboard/profile` - User profile
- `/dashboard/messages` - Messaging system
- `/dashboard/saved-searches` - Saved searches
- `/dashboard/price-alerts` - Price alerts

**Admin Routes:**
- `/admin` - Admin dashboard
- `/admin/users` - User management
- `/admin/boats` - Boat management
- `/admin/inquiries` - Inquiry management
- `/admin/contacts` - Contact management
- `/admin/audit-logs` - Audit logs

### Component Structure

#### Layout Components (`components/layout/`)

**`Navbar.jsx`**
- Responsive navigation bar
- Authentication-aware menu items
- User profile dropdown
- Mobile drawer menu
- Logo and branding

**`Footer.jsx`**
- Site footer with links
- Social media icons
- Contact information
- Legal links (Terms, Privacy, Copyright)

#### Common Components (`components/common/`)

**`PhoneLink.jsx`**
- Clickable phone number component
- Copy-to-clipboard functionality
- Formatted display

**`FloatingContactButton.jsx`**
- Floating action button for quick contact
- Always visible on scroll
- Opens contact modal

**`CompareFloatingButton.jsx`**
- Floating button for boat comparison
- Shows comparison count
- Opens comparison view

**`QuickActionsWidget.jsx`**
- Quick action menu
- Common user actions
- Context-aware actions

**`WelcomeBanner.jsx`**
- Personalized welcome message
- User-specific content
- Dashboard integration

**`PersonalizedSection.jsx`**
- Personalized content section
- User recommendations
- Recent activity

#### Boat Components (`components/boats/`)

**`BoatCard.jsx`**
- Boat listing card component
- Image display
- Price, year, make display
- Click handler for navigation

**`BoatGrid.jsx`**
- Grid layout for boat listings
- Responsive grid system
- Pagination support
- Loading states

**`EmailFriendModal.jsx`**
- Modal for sharing boat via email
- Form validation
- API integration

#### Auth Components (`components/auth/`)

**`ProtectedRoute.jsx`**
- Route guard for authenticated routes
- Redirects to login if not authenticated
- Preserves intended destination

**`AdminProtectedRoute.jsx`**
- Route guard for admin routes
- Checks admin role
- Redirects non-admin users

#### Dashboard Components (`components/dashboard/`)

**`DashboardLayout.jsx`**
- Dashboard page layout
- Sidebar navigation
- Content area
- User context display

#### Admin Components (`components/admin/`)

**`AdminLayout.jsx`**
- Admin panel layout
- Admin-specific navigation
- Statistics display
- Quick actions

### Pages (`pages/`)

#### Public Pages

**`Home.jsx`**
- Landing page
- Hero section with "BOATERS FIRST™" branding
- Featured yachts section
- "Loved By Boaters" section
- Statistics section
- Contact form
- Matches PDF design specification

**`Search.jsx`**
- Advanced search interface
- Multiple filter options
- Results display
- Pagination
- Sort options

**`BoatDetail.jsx`**
- Detailed boat information
- Image gallery
- Specifications table
- Contact seller form
- Share functionality
- Add to favorites

**`Login.jsx`** / **`Register.jsx`**
- Authentication forms
- Form validation
- Error handling
- API integration
- Redirect after success

**Static Pages**: `About.jsx`, `Contact.jsx`, `Terms.jsx`, `Privacy.jsx`, `Copyright.jsx`

#### Dashboard Pages (`pages/dashboard/`)

**`DashboardHome.jsx`**
- User dashboard overview
- Statistics cards
- Recent activity
- Quick actions
- Personalized content

**`MyBoats.jsx`**
- User's boat listings
- Create/edit/delete actions
- Status management
- Image management

**`AddBoat.jsx`** / **`EditBoat.jsx`**
- Boat creation/editing forms
- Multi-step form
- Image upload
- Specification input
- Validation

**`Favorites.jsx`**
- Favorite boats list
- Remove from favorites
- Quick view
- Comparison actions

**`Inquiries.jsx`**
- User's inquiries
- Inquiry status
- Response management
- Communication history

**`Profile.jsx`**
- User profile management
- Edit personal information
- Change password
- Account settings

**`Messenger.jsx`**
- Internal messaging system
- Conversation list
- Message threads
- Real-time updates

**`SavedSearches.jsx`**
- Saved search criteria
- Edit/delete searches
- Run saved searches
- Alert configuration

**`PriceAlerts.jsx`**
- Price alert management
- Create/edit alerts
- Alert history
- Notification settings

**`ProcessManager.jsx`**
- Transaction process tracking
- Step-by-step progress
- Document management
- Status updates

**`Reference.jsx`**
- Reference management
- Document storage
- Sharing capabilities

#### Admin Pages (`pages/admin/`)

**`AdminDashboard.jsx`**
- Admin overview
- Platform statistics
- Recent activity
- Quick actions

**`AdminUsers.jsx`**
- User management
- User list with filters
- Edit user details
- Role management
- Account actions

**`AdminBoats.jsx`**
- Boat listing management
- Approve/reject listings
- Edit listings
- Bulk actions

**`AdminInquiries.jsx`**
- Inquiry management
- Status updates
- Response tracking
- Analytics

**`AdminContacts.jsx`**
- Contact submission management
- View submissions
- Response tracking
- Export functionality

**`AdminAuditLogs.jsx`**
- Audit log viewer
- Filter by user/action/date
- Detailed log entries
- Export capabilities

### Context Providers (`context/`)

#### `AuthContext.jsx`
- **Purpose**: Global authentication state management
- **State**: User object, authentication status, loading state
- **Methods**: `login()`, `logout()`, `updateUser()`, `checkAuth()`
- **Storage**: JWT token in localStorage
- **Auto-refresh**: Token validation on app load

#### `NotificationContext.jsx`
- **Purpose**: Global notification system
- **Features**: Success, error, warning, info notifications
- **Display**: Toast notifications
- **Auto-dismiss**: Configurable timeout

#### `CompareContext.jsx`
- **Purpose**: Boat comparison state management
- **State**: Selected boats for comparison
- **Methods**: `addBoat()`, `removeBoat()`, `clearComparison()`
- **Storage**: localStorage persistence
- **Limits**: Maximum comparison count

### Services (`services/`)

#### `api.js`
- **Purpose**: Centralized API client
- **Configuration**: Base URL from environment variables
- **Interceptors**:
  - Request: Adds JWT token to headers
  - Response: Global error handling
- **Methods**: Organized by feature (auth, boats, search, etc.)
- **Error Handling**: Consistent error format

#### `adminAPI.js`
- **Purpose**: Admin-specific API calls
- **Endpoints**: All admin routes
- **Authentication**: Admin token required
- **Features**: Bulk operations, advanced filtering

### Utilities (`utils/`)

#### `imageUtils.js`
- **Purpose**: Image processing utilities
- **Functions**: Image resizing, format conversion, validation
- **Optimization**: Client-side image optimization

### Styling

#### `theme.js`
- **Purpose**: Material-UI theme configuration
- **Colors**: 
  - Primary: `#1a3a5c` (Dark navy blue)
  - Secondary: `#e67e22` (Orange accent)
- **Typography**: Custom font settings
- **Components**: Custom component styling

#### `index.css`
- **Purpose**: Global CSS styles
- **Content**: Base styles, resets, utility classes

---

## Database Schema

### Core Tables

**`users`**
- User accounts and authentication
- Fields: id, email, password_hash, first_name, last_name, role, created_at
- Roles: buyer, seller, admin
- Indexes: email (unique), role

**`boats`**
- Boat/yacht listings
- Fields: id, user_id, make, model, year, price, length_ft, location, status, created_at
- Status: draft, active, sold, removed
- Foreign Key: user_id → users.id

**`boat_specifications`**
- Detailed boat specifications
- Fields: boat_id, engine_type, fuel_type, max_speed, etc.
- Foreign Key: boat_id → boats.id

**`boat_images`**
- Boat image storage
- Fields: id, boat_id, image_url, is_primary, display_order
- Foreign Key: boat_id → boats.id

**`favorites`**
- User favorite boats
- Fields: user_id, boat_id, created_at
- Composite Primary Key: (user_id, boat_id)

**`inquiries`**
- Boat inquiries from buyers
- Fields: id, boat_id, buyer_id, seller_id, message, status, created_at
- Status: pending, responded, closed

**`saved_searches`**
- Saved search criteria
- Fields: id, user_id, search_criteria (JSON), alert_enabled, created_at

**`price_alerts`**
- Price change alerts
- Fields: id, user_id, boat_id, target_price, alert_sent, created_at

**`boat_comparisons`**
- Boat comparison data
- Fields: user_id, boat_ids (JSON array), created_at

**`contact_submissions`**
- Contact form submissions
- Fields: id, name, email, phone, message, created_at

**`audit_logs`**
- Administrative action logs
- Fields: id, user_id, action, resource_type, resource_id, details (JSON), created_at

### Indexes

- Performance indexes on frequently queried fields
- Foreign key indexes
- Composite indexes for common query patterns

### Migrations

**`database/migrations/001_admin_enhancements.sql`**
- Admin-specific enhancements
- Additional indexes
- Audit log improvements

---

## Key Files and Components

### Configuration Files

**`requirements.txt`**
- Python package dependencies
- Version pinning for stability
- Production-ready dependencies

**`frontend/package.json`**
- Node.js dependencies
- Scripts: dev, build, lint, preview
- React 19, Vite 7, Material-UI 7

**`vite.config.js`**
- Vite build configuration
- React plugin setup
- Development server settings

**`.env` (not in repo)**
- Environment variables
- Database credentials
- JWT secret
- API keys

### Database Scripts

**`database/schema.sql`**
- Complete database schema
- Table definitions
- Indexes
- Constraints

**`database/seed.sql`**
- Initial seed data
- Test users
- Sample boat listings

**`database/setup-db.ps1` / `setup-db.sh`**
- Database setup automation
- Schema creation
- Seed data loading

### Documentation

**`HOW_TO_RUN.md`**
- Setup instructions
- Running backend and frontend
- Database setup
- Troubleshooting

---

## Development Workflow

### Backend Development

1. **Activate Virtual Environment**
   ```bash
   venv\Scripts\activate  # Windows
   source venv/bin/activate  # Mac/Linux
   ```

2. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run Development Server**
   ```bash
   python main.py
   ```
   - Server runs on `http://127.0.0.1:8000`
   - Auto-reload on code changes
   - API docs at `http://127.0.0.1:8000/docs`

### Frontend Development

1. **Navigate to Frontend Directory**
   ```bash
   cd frontend
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Run Development Server**
   ```bash
   npm run dev
   ```
   - Server runs on `http://localhost:5173`
   - Hot module replacement (HMR)
   - Fast refresh

### Database Setup

1. **Create PostgreSQL Database**
   ```sql
   CREATE DATABASE yachtx;
   ```

2. **Run Schema**
   ```bash
   psql -U username -d yachtx -f database/schema.sql
   ```

3. **Seed Data (Optional)**
   ```bash
   psql -U username -d yachtx -f database/seed.sql
   ```

### Build for Production

**Backend:**
- No build step required (Python)
- Deploy with virtual environment
- Use production ASGI server (Gunicorn + Uvicorn)

**Frontend:**
```bash
cd frontend
npm run build
```
- Output in `frontend/dist/`
- Optimized and minified
- Ready for static hosting

---

## Security Considerations

### Backend Security

- **Password Hashing**: Bcrypt with salt rounds
- **JWT Tokens**: Secure token generation and validation
- **CORS**: Configured for specific origins
- **SQL Injection**: Prevented via parameterized queries (asyncpg)
- **Input Validation**: Pydantic models validate all inputs
- **Role-Based Access**: Admin and seller role checks

### Frontend Security

- **Token Storage**: JWT in localStorage (consider httpOnly cookies for production)
- **XSS Protection**: React's built-in XSS protection
- **CSRF**: Handled via CORS and token validation
- **Input Sanitization**: Form validation before submission

---

## Performance Optimizations

### Backend

- **Connection Pooling**: asyncpg connection pool (max 10 connections)
- **Async Operations**: All database operations are async
- **Indexing**: Strategic database indexes
- **Query Optimization**: Efficient SQL queries

### Frontend

- **Code Splitting**: Route-based code splitting
- **Lazy Loading**: Components loaded on demand
- **Image Optimization**: Optimized image formats
- **Bundle Size**: Vite optimizations for production builds

---

## Testing Strategy

### Backend Testing
- Unit tests for business logic
- Integration tests for API endpoints
- Database transaction tests

### Frontend Testing
- Component unit tests
- Integration tests for user flows
- E2E tests for critical paths

---

## Deployment Considerations

### Backend Deployment
- Use production ASGI server (Gunicorn + Uvicorn)
- Environment variables for configuration
- Database connection pooling
- Logging and monitoring

### Frontend Deployment
- Static file hosting (CDN recommended)
- Environment variables for API URL
- Build optimization
- Asset caching strategies

---

## Future Enhancements

- Real-time notifications (WebSockets)
- Advanced analytics dashboard
- Mobile app (React Native)
- Payment integration
- Email service integration
- Image CDN integration
- Advanced search with Elasticsearch
- Multi-language support

---

## Conclusion

This project follows modern software engineering practices with a clear separation of concerns, scalable architecture, and maintainable codebase. The structure supports both development velocity and production reliability.

**Key Strengths:**
- Clean architecture with separation of concerns
- Type-safe backend with Pydantic
- Modern React patterns with hooks and context
- Comprehensive API with proper error handling
- Security best practices implemented
- Scalable database design

**Maintenance Notes:**
- Keep dependencies updated regularly
- Monitor database performance and optimize queries
- Review and update security practices
- Maintain comprehensive documentation
- Regular code reviews and refactoring

---

**Document Version:** 1.0.0  
**Last Reviewed:** February 2026  
**Next Review:** Quarterly
