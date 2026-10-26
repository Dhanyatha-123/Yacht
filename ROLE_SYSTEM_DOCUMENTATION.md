# YachtX Role System Documentation

> **Internal System Documentation for Senior Engineers**  
> Last Updated: February 2026  
> Version: 2.0

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [SELLER Role](#2-seller-role)
3. [BUYER Role](#3-buyer-role)
4. [ADMIN Role](#4-admin-role)
5. [Interactions Between Roles](#5-interactions-between-roles)
6. [Security & Hardening](#6-security--hardening)
7. [Summary Diagram](#7-summary-diagram)

---

## 1. Executive Summary

YachtX implements a **contextual role system** rather than rigid role enforcement. The key design principle is:

```
┌──────────────────────────────────────────────────────────────────┐
│ CONTEXTUAL ROLES:                                                │
│   • Listing Owner → SELLER (for that boat)                       │
│   • Inquiry Sender → BUYER (for that interaction)                │
│   • role='admin' → ADMIN (global privilege)                      │
│                                                                  │
│ Any authenticated user can:                                      │
│   • Create boat listings (becomes seller for that boat)          │
│   • Send inquiries on boats they don't own (becomes buyer)       │
└──────────────────────────────────────────────────────────────────┘
```

### Persistent Flags

| Flag | Purpose | Stored In |
|------|---------|-----------|
| `role` | Base role ('buyer', 'seller', 'admin') | `users.role` |
| `is_admin` | Admin access (implicit: role='admin') | `users.role` |
| `is_support_admin` | Read-only admin access | `users.is_support_admin` |

---

## 2. SELLER Role

### 2.1 Role Purpose

| Aspect | Description |
|--------|-------------|
| **Problem Solved** | Enables users to list yachts for sale, receive inquiries, and communicate with potential buyers |
| **Real-Life Users** | Yacht owners, brokers, dealers, private sellers |

### 2.2 Authentication & Authorization

#### Login/Signup Flow
```
1. User registers at POST /api/auth/register
   └── role defaults to 'buyer' but can be set to 'seller'
2. JWT token issued (7-day expiry)
3. Token stored in localStorage
4. Token attached to all API requests via Authorization header
```

#### JWT Payload Structure
```json
{
  "userId": 123,
  "email": "seller@example.com",
  "role": "seller",
  "iat": 1706000000,
  "exp": 1706604800
}
```

#### Middleware Chain (Backend)
```
Python (FastAPI):
  request → HTTPBearer → decode_access_token() → get_current_user()
           └── Validates JWT
                    └── Fetches user from DB
                              └── Checks is_active

Node.js (Express):
  request → authenticateToken → [route handler]
           └── jwt.verify()
                    └── Fetches user from DB
                              └── Checks is_active
```

#### Authorization Rules

| Action | Check | Code Location |
|--------|-------|---------------|
| Create listing | `authenticated` | `app/api/boats.py:153` |
| Edit listing | `boat.user_id == user.id OR admin` | `app/api/boats.py:189` |
| Delete listing | `boat.user_id == user.id OR admin` | `app/api/boats.py:245` |
| View received inquiries | `inquiry.receiver_id == user.id` | `app/api/inquiries.py:115` |
| Reply to inquiry | `inquiry.sender_id == user.id OR receiver_id == user.id` | `app/api/inquiries.py:193` |

### 2.3 Data Model

#### Primary Tables

```sql
-- BOATS TABLE (Seller's listings)
CREATE TABLE boats (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),  -- SELLER
    status VARCHAR(20) CHECK (status IN ('draft', 'pending', 'active', 'sold', 'archived')),
    title VARCHAR(255) NOT NULL,
    make VARCHAR(100),
    model VARCHAR(100),
    year INTEGER,
    asking_price DECIMAL(12,2),
    -- ... additional fields
    created_at TIMESTAMP DEFAULT NOW()
);

-- BOAT STATUS STATE MACHINE
-- draft → pending → active → sold
--                        ↘ archived
--         cancelled ←────────┘
```

#### Relationships

```
users (seller)
  │
  ├──< boats (one seller → many boats)
  │      │
  │      └──< inquiries (one boat → many inquiries)
  │             │
  │             └──< messages (one inquiry → many messages)
  │
  └──< deals (seller_id) (one seller → many deals)
```

### 2.4 API Layer

#### Seller-Specific Endpoints

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| `POST` | `/api/boats` | Create new listing | Required |
| `GET` | `/api/boats/user/my-boats` | Get seller's listings | Required |
| `PUT` | `/api/boats/:id` | Update listing | Owner/Admin |
| `DELETE` | `/api/boats/:id` | Delete listing | Owner/Admin |
| `POST` | `/api/boats/:id/images` | Add boat images | Owner/Admin |
| `GET` | `/api/inquiries/received` | Get inquiries on my boats | Required |
| `POST` | `/api/inquiries/:id/messages` | Reply to inquiry | Participant |

#### Request/Response Examples

**Create Listing:**
```http
POST /api/boats
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "2020 Hanse 388 Sailboat",
  "make": "Hanse",
  "model": "388",
  "year": 2020,
  "asking_price": 285000,
  "location": "Miami, FL",
  "description": "Well-maintained cruiser..."
}
```

```json
// Response 201 Created
{
  "message": "Boat listing created",
  "boat": {
    "id": 123,
    "user_id": 45,
    "title": "2020 Hanse 388 Sailboat",
    "status": "active",
    "created_at": "2026-02-05T10:00:00Z"
  }
}
```

### 2.5 Business Logic Flow

```
SELLER LIFECYCLE:

1. ONBOARDING
   └── Register account (role: 'buyer' or 'seller')
       └── JWT issued

2. LISTING CREATION
   └── POST /api/boats
       └── Listing created with status='active'
           └── Assigned boat.user_id = current_user.id (seller)

3. INQUIRY HANDLING
   └── Buyer sends inquiry
       └── Deal created (status='initiated')
           └── Inquiry linked to deal
               └── Seller receives in /api/inquiries/received

4. NEGOTIATION
   └── Seller replies via /api/inquiries/:id/messages
       └── Inquiry status → 'replied'
           └── Multiple back-and-forth messages

5. DEAL RESOLUTION (Admin-controlled)
   └── Admin marks deal as 'sold'
       └── Boat status → 'sold'
           └── Other active deals → 'cancelled'

   OR

   └── Admin marks deal as 'cancelled'
       └── Boat remains 'active'
```

### 2.6 Frontend Flow

#### Seller Pages/Screens

| Page | Route | Actions |
|------|-------|---------|
| Dashboard Home | `/dashboard` | View stats, recent inquiries |
| My Boats | `/dashboard/boats` | View all listings, edit, delete |
| Add Boat | `/dashboard/boats/new` | Create new listing |
| Edit Boat | `/dashboard/boats/:id/edit` | Update listing details |
| Inquiries | `/dashboard/inquiries` | View/reply to inquiries |
| Messages | `/dashboard/messages` | Conversation threads |

#### Conditional Rendering

```jsx
// frontend/src/pages/dashboard/MyBoats.jsx
// Shows boats where user_id = current user
const { data } = await boatsAPI.getMyBoats();

// Reply button only shows for received inquiries
{tab === 0 && (  // tab 0 = received
  <Button onClick={() => handleReply(inquiry.id)}>
    Reply
  </Button>
)}
```

---

## 3. BUYER Role

### 3.1 Role Purpose

| Aspect | Description |
|--------|-------------|
| **Problem Solved** | Enables users to discover yachts, send inquiries, and communicate with sellers |
| **Real-Life Users** | Individuals looking to purchase a yacht, yacht enthusiasts, prospective owners |

### 3.2 Authentication & Authorization

#### Guest vs Authenticated Buyers

| Feature | Guest | Authenticated |
|---------|-------|---------------|
| Browse listings | ✅ | ✅ |
| View boat details | ✅ | ✅ |
| Send inquiry | ✅ (requires email) | ✅ |
| Track inquiries | ❌ | ✅ |
| Favorites | ❌ | ✅ |
| Deal linking | New deal per inquiry | Reuses active deal |

#### Middleware for Optional Auth

```javascript
// backend/src/middleware/auth.js
const optionalAuth = async (req, res, next) => {
  const token = authHeader?.split(' ')[1];
  if (token) {
    // Attach user if valid token
    req.user = result.rows[0];
  }
  next();  // Continue regardless
};
```

### 3.3 Data Model

#### Primary Tables

```sql
-- INQUIRIES TABLE (Buyer's inquiries)
CREATE TABLE inquiries (
    id SERIAL PRIMARY KEY,
    boat_id INTEGER REFERENCES boats(id),
    deal_id INTEGER REFERENCES deals(id),
    sender_id INTEGER REFERENCES users(id),     -- BUYER (NULL for guests)
    receiver_id INTEGER REFERENCES users(id),   -- SELLER
    sender_name VARCHAR(100),
    sender_email VARCHAR(255) NOT NULL,
    sender_phone VARCHAR(50),
    subject VARCHAR(255),
    message TEXT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('unread', 'read', 'replied', 'archived')),
    created_at TIMESTAMP DEFAULT NOW()
);

-- DEALS TABLE (Buyer-Seller interaction)
CREATE TABLE deals (
    id SERIAL PRIMARY KEY,
    boat_id INTEGER REFERENCES boats(id),
    seller_id INTEGER REFERENCES users(id),
    buyer_id INTEGER REFERENCES users(id),  -- NULL for guests
    status VARCHAR(20) CHECK (status IN ('initiated', 'in_discussion', 'sold', 'cancelled')),
    created_at TIMESTAMP DEFAULT NOW(),
    closed_at TIMESTAMP
);

-- FAVORITES TABLE
CREATE TABLE favorites (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),  -- BUYER
    boat_id INTEGER REFERENCES boats(id),
    UNIQUE(user_id, boat_id)
);
```

#### Deal Status State Machine

```
                    ┌─────────────┐
                    │  initiated  │
                    └──────┬──────┘
                           │ (admin updates)
                    ┌──────▼──────┐
                    │in_discussion│
                    └──────┬──────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
    ┌──────▼──────┐ ┌──────▼──────┐        │
    │    sold     │ │  cancelled  │◄───────┘
    └─────────────┘ └─────────────┘
    (terminal)      (terminal)
```

### 3.4 API Layer

#### Buyer-Specific Endpoints

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| `GET` | `/api/boats` | Browse listings | Optional |
| `GET` | `/api/boats/:id` | View boat details | Optional |
| `GET` | `/api/boats/:id/similar` | Get similar boats | Public |
| `POST` | `/api/inquiries` | Send inquiry | Optional (email required for guests) |
| `GET` | `/api/inquiries/sent` | Get my sent inquiries | Required |
| `GET` | `/api/favorites` | Get favorites | Required |
| `POST` | `/api/favorites/:boatId` | Add to favorites | Required |
| `DELETE` | `/api/favorites/:boatId` | Remove from favorites | Required |

#### Inquiry Creation Logic

```python
# app/api/inquiries.py - send_inquiry()

# 1. Validate request
if not current_user and not inquiry.email:
    raise HTTPException(400, "Email is required for guests")

# 2. Check contextual role (can't inquire on own boat)
if current_user and current_user["id"] == boat["user_id"]:
    raise HTTPException(400, "You cannot send an inquiry on your own boat")

# 3. Deal creation with deduplication
if buyer_id is not None:
    # Logged-in: Check for existing active deal
    existing_deal = await db.fetchrow(
        """SELECT id FROM deals 
           WHERE boat_id = $1 AND buyer_id = $2 
           AND status IN ('initiated', 'in_discussion')""",
        inquiry.boat_id, buyer_id
    )
    if existing_deal:
        deal_id = existing_deal["id"]  # Reuse
    else:
        # Create new deal
        deal = await db.fetchrow(
            """INSERT INTO deals (boat_id, seller_id, buyer_id, status)
               VALUES ($1, $2, $3, 'initiated') RETURNING *""",
            inquiry.boat_id, boat["user_id"], buyer_id
        )
        deal_id = deal["id"]
else:
    # Guest: Always create new deal
    deal = await db.fetchrow(...)
    deal_id = deal["id"]

# 4. Create inquiry linked to deal
result = await db.fetchrow(
    """INSERT INTO inquiries (boat_id, deal_id, ...) VALUES (...)""",
    inquiry.boat_id, deal_id, ...
)
```

### 3.5 Business Logic Flow

```
BUYER LIFECYCLE:

1. DISCOVERY
   └── Browse /api/boats
       └── Filter by make, price, length, location
           └── View featured boats

2. INTEREST
   └── View boat details /api/boats/:id
       └── Add to favorites (if authenticated)
           └── Compare multiple boats

3. INQUIRY
   └── POST /api/inquiries
       └── [Transaction Start]
           ├── Create/Reuse deal
           ├── Create inquiry linked to deal
           └── Increment boat.inquiries_count
       └── [Transaction Commit]

4. NEGOTIATION
   └── Receive seller's reply
       └── Send follow-up via /api/inquiries/:id/messages
           └── Continue conversation

5. OUTCOME (Buyer has no direct control)
   └── Admin marks deal as 'sold'
       └── Purchase completed (offline)

   OR

   └── Admin marks deal as 'cancelled'
       └── Negotiation ended
```

### 3.6 Frontend Flow

#### Buyer Pages/Screens

| Page | Route | Actions |
|------|-------|---------|
| Home | `/` | Featured boats, search |
| Search | `/search` | Filter, sort, browse |
| Boat Detail | `/boats/:id` | View details, send inquiry |
| Compare | `/compare` | Side-by-side comparison |
| Favorites | `/dashboard/favorites` | View saved boats |
| Sent Inquiries | `/dashboard/inquiries` | Track inquiries |

#### Inquiry Form (Boat Detail Page)

```jsx
// frontend/src/pages/BoatDetail.jsx
const handleInquiry = async (formData) => {
  const response = await inquiriesAPI.send({
    boat_id: boat.id,
    message: formData.message,
    name: formData.name,     // For guests
    email: formData.email,   // For guests
    phone: formData.phone
  });
};
```

---

## 4. ADMIN Role

### 4.1 Role Purpose

| Aspect | Description |
|--------|-------------|
| **Problem Solved** | Platform oversight, deal management, user management, content moderation |
| **Real-Life Users** | Platform administrators, support staff, operations team |

### 4.2 Authentication & Authorization

#### Admin Hierarchy

```
┌─────────────────────────────────────────────────────────┐
│                    ADMIN HIERARCHY                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  FULL ADMIN (role='admin', is_support_admin=false)      │
│  ├── All read operations                                │
│  ├── Update deal status                                 │
│  ├── Add admin notes                                    │
│  ├── Manage users                                       │
│  └── Delete/restore content                             │
│                                                         │
│  SUPPORT ADMIN (role='admin', is_support_admin=true)    │
│  ├── All read operations                                │
│  └── ❌ Cannot modify anything                          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

#### Middleware Chain

```python
# app/core/dependencies.py

def require_admin_or_support():
    """Allow both full admins and support admins"""
    async def admin_checker(current_user: dict = Depends(get_current_user)):
        if current_user["role"] != "admin":
            raise HTTPException(403, "Admin privileges required")
        return current_user
    return admin_checker

def require_full_admin():
    """Require full admin (not support read-only)"""
    async def full_admin_checker(current_user: dict = Depends(get_current_user)):
        if current_user["role"] != "admin":
            raise HTTPException(403, "Admin privileges required")
        if current_user.get("is_support_admin", False):
            raise HTTPException(403, "Support admins have read-only access")
        return current_user
    return full_admin_checker
```

#### Route Protection

```python
# app/api/admin.py
router.dependencies = [Depends(get_current_user), Depends(require_admin_or_support())]

# Write operations require full admin
@router.put("/deals/{id}/status")
async def update_deal_status(id: int, ..., current_user: dict = Depends(require_full_admin)):
    ...
```

### 4.3 Data Model

#### Admin-Specific Tables

```sql
-- AUDIT LOGS TABLE
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    admin_id INTEGER REFERENCES users(id),
    action_type VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id INTEGER,
    old_values JSONB,
    new_values JSONB,
    reason TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- DEAL ADMIN NOTES (Internal notes - not visible to buyer/seller)
CREATE TABLE deal_admin_notes (
    id SERIAL PRIMARY KEY,
    deal_id INTEGER REFERENCES deals(id) ON DELETE CASCADE,
    admin_id INTEGER REFERENCES users(id),
    note TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- INQUIRY ADMIN NOTES
CREATE TABLE inquiry_admin_notes (
    id SERIAL PRIMARY KEY,
    inquiry_id INTEGER REFERENCES inquiries(id) ON DELETE CASCADE,
    admin_id INTEGER REFERENCES users(id),
    note TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

### 4.4 API Layer

#### Admin Endpoints

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| `GET` | `/api/admin/dashboard` | Dashboard stats | Admin |
| `GET` | `/api/admin/analytics` | Time-series analytics | Admin |
| `GET` | `/api/admin/users` | List users | Admin |
| `PUT` | `/api/admin/users/:id` | Update user | Full Admin |
| `GET` | `/api/admin/boats` | List all boats | Admin |
| `PUT` | `/api/admin/boats/:id/status` | Change boat status | Full Admin |
| `DELETE` | `/api/admin/boats/:id` | Delete boat | Full Admin |
| `GET` | `/api/admin/inquiries` | List all inquiries | Admin |
| `GET` | `/api/admin/deals` | List all deals | Admin |
| `GET` | `/api/admin/deals/:id` | Deal details with full context | Admin |
| `PUT` | `/api/admin/deals/:id/status` | Update deal status | Full Admin |
| `POST` | `/api/admin/deals/:id/notes` | Add internal note | Full Admin |
| `GET` | `/api/admin/audit-logs` | View audit logs | Admin |

#### Deal Status Update Logic

```python
# app/api/admin.py - update_deal_status()

# 1. Idempotency check (terminal states are immutable)
if old_deal["status"] in ["sold", "cancelled"]:
    raise HTTPException(400, f"Deal is already {old_deal['status']}")

# 2. Update deal
if new_status == "sold":
    # a. Set closed_at timestamp
    await conn.fetchrow(
        "UPDATE deals SET status=$1, closed_at=NOW() WHERE id=$2",
        new_status, id
    )
    
    # b. Update boat to sold
    await conn.execute(
        "UPDATE boats SET status='sold' WHERE id=$1",
        old_deal["boat_id"]
    )
    
    # c. Cancel all other active deals for this boat
    await conn.execute(
        """UPDATE deals SET status='cancelled' 
           WHERE boat_id=$1 AND id!=$2 
           AND status IN ('initiated', 'in_discussion')""",
        old_deal["boat_id"], id
    )

# 3. Audit log
await log_action(
    admin_id=current_user["id"],
    action_type="deal_status_change",
    entity_type="deal",
    entity_id=id,
    old_values={"status": old_deal["status"]},
    new_values={"status": new_status, "reason": reason}
)
```

### 4.5 Business Logic Flow

```
ADMIN LIFECYCLE:

1. MONITORING
   └── View dashboard /api/admin/dashboard
       ├── Total users, boats, inquiries
       ├── Boats by status
       └── Recent user registrations

2. USER MANAGEMENT
   └── GET /api/admin/users (list)
       └── PUT /api/admin/users/:id (update role, deactivate)
           └── Audit log created

3. CONTENT MODERATION
   └── GET /api/admin/boats (all statuses)
       └── PUT /api/admin/boats/:id/status (approve/reject/archive)
           └── Audit log created

4. DEAL OVERSIGHT
   └── GET /api/admin/deals (list all)
       └── GET /api/admin/deals/:id (full context)
           ├── Deal details
           ├── Boat details
           ├── Seller details
           ├── Buyer details
           ├── All inquiries
           ├── All messages
           └── Admin notes

5. DEAL RESOLUTION
   └── PUT /api/admin/deals/:id/status
       ├── 'in_discussion' → Progress deal
       ├── 'sold' → Complete (marks boat sold, cancels other deals)
       └── 'cancelled' → End negotiation

6. INTERNAL NOTES
   └── POST /api/admin/deals/:id/notes
       └── Not visible to buyer/seller
           └── Used for internal tracking
```

### 4.6 Frontend Flow

#### Admin Pages/Screens

| Page | Route | Actions |
|------|-------|---------|
| Dashboard | `/admin` | Stats, charts, overview |
| Users | `/admin/users` | List, filter, edit, bulk actions |
| Boats | `/admin/boats` | List, filter, status change, delete |
| Inquiries | `/admin/inquiries` | View all, add notes |
| Contacts | `/admin/contacts` | Contact form submissions |
| Audit Logs | `/admin/audit-logs` | Activity history |

#### Admin Route Protection (Frontend)

```jsx
// frontend/src/components/auth/AdminProtectedRoute.jsx
const AdminProtectedRoute = ({ children }) => {
  const { isAuthenticated, user } = useAuth();

  if (!isAuthenticated) {
    return <Navigate to="/login" />;
  }

  if (user?.role !== 'admin') {
    return <Typography color="error">Access Denied</Typography>;
  }

  return children;
};
```

### 4.7 Admin Overrides & Safety

#### What Admins Can Modify

| Entity | Mutable Fields | Immutable Fields |
|--------|---------------|------------------|
| Users | `role`, `is_active` | `id`, `email`, `created_at` |
| Boats | `status` | `id`, `user_id`, `created_at` |
| Deals | `status` (if not terminal) | `id`, `boat_id`, `seller_id`, `buyer_id` |
| Inquiries | `status` | `message`, `sender_*` |

#### Safety Guards

```python
# Prevent self-deactivation
if id == current_user["id"] and request.get("is_active") is False:
    raise HTTPException(400, "Cannot deactivate your own account")

# Terminal state idempotency
if old_deal["status"] in ["sold", "cancelled"]:
    raise HTTPException(400, "Cannot update terminal deal")

# Soft delete by default (recoverable)
await conn.execute(
    "UPDATE boats SET deleted_at = NOW() WHERE id = $1",
    id
)
```

#### Audit Log Fields

```json
{
  "id": 1,
  "admin_id": 1,
  "action_type": "deal_status_change",
  "entity_type": "deal",
  "entity_id": 42,
  "old_values": {"status": "initiated"},
  "new_values": {"status": "sold", "reason": "Purchase completed"},
  "reason": "Purchase completed",
  "ip_address": "192.168.1.1",
  "user_agent": "Mozilla/5.0...",
  "created_at": "2026-02-05T10:30:00Z"
}
```

---

## 5. Interactions Between Roles

### 5.1 Seller ↔ Buyer Communication

```
BUYER                    SYSTEM                    SELLER
  │                         │                         │
  │  Send Inquiry           │                         │
  │ ───────────────────────►│                         │
  │                         │  Create Deal            │
  │                         │  (status='initiated')   │
  │                         │                         │
  │                         │  Link Inquiry to Deal   │
  │                         │                         │
  │                         │  Notify Seller          │
  │                         │ ───────────────────────►│
  │                         │                         │
  │                         │                   Reply │
  │                         │◄───────────────────────│
  │                         │                         │
  │  Receive Reply          │                         │
  │◄───────────────────────│                         │
  │                         │                         │
  │  Send Follow-up         │                         │
  │ ───────────────────────►│                         │
  │                         │ ───────────────────────►│
  │                         │                         │
```

### 5.2 Admin Intervention Points

```
┌──────────────────────────────────────────────────────────────┐
│                    ADMIN INTERVENTION POINTS                  │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  1. USER MANAGEMENT                                          │
│     └── Deactivate problematic users                         │
│     └── Change user roles                                    │
│     └── Bulk operations                                      │
│                                                              │
│  2. CONTENT MODERATION                                       │
│     └── Approve/reject listings                              │
│     └── Delete inappropriate content                         │
│     └── Restore deleted content                              │
│                                                              │
│  3. DEAL MANAGEMENT                                          │
│     └── Progress deal status                                 │
│     └── Mark deal as sold (finalizes transaction)            │
│     └── Cancel deal (terminates negotiation)                 │
│                                                              │
│  4. DISPUTE RESOLUTION                                       │
│     └── View full conversation history                       │
│     └── Add internal notes                                   │
│     └── Take appropriate action                              │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### 5.3 Event Triggers

| Event | Trigger | Consequence |
|-------|---------|-------------|
| Inquiry sent | Buyer action | Deal created/reused, Inquiry linked |
| Reply sent | Seller action | Inquiry status → 'replied' |
| Deal marked sold | Admin action | Boat → 'sold', Other deals → 'cancelled' |
| User deactivated | Admin action | User cannot login, Token invalidated |
| Boat deleted | Owner/Admin | Cascade delete: images, specs, favorites |

---

## 6. Security & Hardening

### 6.1 Prevented Actions

| Attack Vector | Prevention | Code Location |
|---------------|------------|---------------|
| Inquire on own boat | Contextual check | `inquiries.py:25` |
| Duplicate active deals | Partial unique index | `schema.sql:280` |
| Guest deal spam | New deal per guest (documented) | `inquiries.py:63` |
| Orphan deals | Database transaction | `inquiries.py:19` |
| Double-selling | Terminal state check | `admin.py:945` |
| Self-deactivation | Admin check | `admin.py:251` |
| Unauthorized edit | Owner/Admin check | `boats.py:189` |

### 6.2 Idempotent Endpoints

```python
# Deal status update is idempotent for terminal states
# Calling PUT /deals/:id/status multiple times with 'sold' will:
# - First call: Update to sold ✓
# - Second call: Return 400 "Deal is already sold" ✓

if old_deal["status"] in ["sold", "cancelled"]:
    raise HTTPException(400, f"Deal is already {old_deal['status']}")
```

### 6.3 Transaction Safety

```python
# Inquiry creation uses transaction
async with db.transaction():
    # 1. Create/find deal
    deal = await db.fetchrow(...)
    
    # 2. Create inquiry
    inquiry = await db.fetchrow(...)
    
    # 3. Update boat stats
    await db.execute("UPDATE boats SET inquiries_count = ...")
    
    # If any step fails, entire transaction rolls back
```

### 6.4 Partial Unique Index

```sql
-- Prevents duplicate active deals for same buyer on same boat
-- BUT allows multiple deals for:
--   - Guest buyers (buyer_id IS NULL)
--   - Closed deals (status NOT IN ('initiated', 'in_discussion'))
CREATE UNIQUE INDEX idx_deals_unique_active 
ON deals(boat_id, buyer_id) 
WHERE buyer_id IS NOT NULL AND status IN ('initiated', 'in_discussion');
```

### 6.5 Permission Matrix

| Action | Guest | Buyer | Seller | Support Admin | Full Admin |
|--------|-------|-------|--------|---------------|------------|
| Browse boats | ✅ | ✅ | ✅ | ✅ | ✅ |
| Send inquiry | ✅ | ✅ | ✅ (not own) | ✅ | ✅ |
| Create listing | ❌ | ✅ | ✅ | ❌ | ✅ |
| Edit own listing | ❌ | ✅ | ✅ | ❌ | ✅ |
| View admin dashboard | ❌ | ❌ | ❌ | ✅ | ✅ |
| Update deal status | ❌ | ❌ | ❌ | ❌ | ✅ |
| Add admin notes | ❌ | ❌ | ❌ | ❌ | ✅ |
| View audit logs | ❌ | ❌ | ❌ | ✅ | ✅ |

---

## 7. Summary Diagram

### 7.1 System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                          YACHTX PLATFORM                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐             │
│  │   BUYER     │    │   SELLER    │    │   ADMIN     │             │
│  │             │    │             │    │             │             │
│  │ • Browse    │    │ • List boat │    │ • Dashboard │             │
│  │ • Inquire   │    │ • Reply     │    │ • Users     │             │
│  │ • Favorite  │    │ • Edit      │    │ • Boats     │             │
│  │ • Compare   │    │ • Delete    │    │ • Deals     │             │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘             │
│         │                  │                  │                     │
│         └────────────┬─────┴──────────────────┘                     │
│                      │                                              │
│                      ▼                                              │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      API LAYER                               │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐     │   │
│  │  │  /auth   │  │  /boats  │  │/inquiries│  │  /admin  │     │   │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘     │   │
│  └──────────────────────────┬──────────────────────────────────┘   │
│                             │                                       │
│                             ▼                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    DATABASE (PostgreSQL)                     │   │
│  │                                                              │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │   │
│  │  │  users  │  │  boats  │  │  deals  │  │inquiries│        │   │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘        │   │
│  │                                                              │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │   │
│  │  │messages │  │favorites│  │audit_log│  │admin_not│        │   │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 7.2 Deal Lifecycle Flow

```
BUYER                    SYSTEM                    SELLER                   ADMIN
  │                         │                         │                        │
  │ Browse Boats            │                         │                        │
  │◄────────────────────────│                         │                        │
  │                         │                         │                        │
  │ Send Inquiry ───────────┼────────────────────────►│                        │
  │                         │                         │                        │
  │                         │ Deal Created            │                        │
  │                         │ (status=initiated)      │                        │
  │                         │                         │                        │
  │                         │◄───────────────────────│ Reply                   │
  │◄────────────────────────│                         │                        │
  │                         │                         │                        │
  │ Follow-up ──────────────┼────────────────────────►│                        │
  │                         │                         │                        │
  │                         │                         │                        │
  │                         │                         │     Monitor ───────────┤
  │                         │                         │◄──────────────────────│
  │                         │                         │                        │
  │                         │                         │     Update Status ────►│
  │                         │                         │     (in_discussion)    │
  │                         │                         │                        │
  │ ... negotiation ...     │                         │                        │
  │                         │                         │                        │
  │                         │                         │     Mark SOLD ─────────┤
  │                         │◄────────────────────────┼───────────────────────│
  │                         │                         │                        │
  │                         │ Boat → sold             │                        │
  │                         │ Other deals → cancelled │                        │
  │                         │                         │                        │
  │ Deal Complete           │                         │ Deal Complete          │
  │◄────────────────────────┤                         │◄───────────────────────│
  │                         │                         │                        │
```

### 7.3 Data Flow Summary

```
┌──────────────────────────────────────────────────────────────────┐
│                        DATA FLOW SUMMARY                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  BUYER → Inquiry → DEAL → Inquiry → SELLER                       │
│                      │                                           │
│                      ▼                                           │
│                    ADMIN                                         │
│                      │                                           │
│                      ▼                                           │
│              Deal Resolution                                     │
│              (sold/cancelled)                                    │
│                      │                                           │
│                      ▼                                           │
│              Audit Log Entry                                     │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Appendix A: File Reference

### Backend (Python/FastAPI)

| File | Purpose |
|------|---------|
| `app/api/auth.py` | Authentication endpoints |
| `app/api/boats.py` | Boat CRUD operations |
| `app/api/inquiries.py` | Inquiry/messaging system |
| `app/api/admin.py` | Admin endpoints |
| `app/core/dependencies.py` | Auth middleware, role checks |
| `app/core/security.py` | JWT, password hashing |
| `app/services/audit_log.py` | Audit logging |

### Backend (Node.js/Express)

| File | Purpose |
|------|---------|
| `backend/src/routes/auth.js` | Authentication endpoints |
| `backend/src/routes/boats.js` | Boat CRUD operations |
| `backend/src/routes/inquiries.js` | Inquiry/messaging system |
| `backend/src/routes/admin.js` | Admin endpoints |
| `backend/src/middleware/auth.js` | Auth middleware, role checks |
| `backend/src/services/auditLog.js` | Audit logging |

### Frontend (React)

| File | Purpose |
|------|---------|
| `frontend/src/context/AuthContext.jsx` | Auth state management |
| `frontend/src/components/auth/ProtectedRoute.jsx` | Route protection |
| `frontend/src/components/auth/AdminProtectedRoute.jsx` | Admin route protection |
| `frontend/src/pages/dashboard/*` | User dashboard pages |
| `frontend/src/pages/admin/*` | Admin dashboard pages |
| `frontend/src/services/api.js` | API client |

### Database

| File | Purpose |
|------|---------|
| `database/schema.sql` | Full database schema |
| `database/migrations/002_deals_table.sql` | Deals table migration |
| `database/migrations/003_deal_admin_notes.sql` | Admin notes migration |
| `database/migrations/004_support_admin_flag.sql` | Support admin flag |

---

*Document generated: February 5, 2026*
