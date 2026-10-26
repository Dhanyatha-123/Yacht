# YachtX Deal Lifecycle Documentation

This document describes how yacht deals take place between Seller, Buyer, and Admin based on the current system implementation.

---

## SELLER JOURNEY

### Step 1: Account Creation
- Seller registers with role `"seller"` (or admin assigns seller role)
- Account must be `is_active = true` to perform actions

### Step 2: Create Boat Listing
- Seller navigates to dashboard → "Add Boat"
- Fills out boat details (title, make, model, year, price, location, description, specifications, images)
- **Boat Status Options:**
  - `"draft"` - Work in progress, not visible to buyers
  - `"pending"` - Submitted for admin approval (if admin approval workflow exists)
  - `"active"` - **Default status** - Immediately visible to buyers and searchable
- System automatically sets `user_id` to seller's ID
- Boat is created with `status = 'active'` by default (based on `app/api/boats.py` line 163)

### Step 3: Manage Listing
- Seller can view all their boats in dashboard
- Seller can edit boat details (only their own boats, unless admin)
- Seller can update boat information at any time
- Boat `inquiries_count` increments automatically when inquiries are received

### Step 4: Receive Inquiries
- When a buyer inquires about their boat, seller receives notification
- Inquiry appears in seller's dashboard under "Inquiries" → "Received" tab
- Inquiry status: `"unread"` → `"read"` (when seller views it) → `"replied"` (when seller responds)

### Step 5: Respond to Buyer
- Seller views inquiry details (buyer name, email, phone, message)
- Seller can reply via message thread within the inquiry
- Each reply creates a new entry in `messages` table linked to the `inquiry_id`
- Inquiry status automatically changes to `"replied"` when seller sends first reply
- Conversation continues through message thread

### Step 6: Deal Completion (Manual)
- **No automated deal completion workflow exists**
- When deal is finalized (outside system), seller or admin manually updates boat status to `"sold"`
- Boat status can be changed to:
  - `"sold"` - Deal completed
  - `"archived"` - Listing removed/ended
- Seller can continue managing other active listings

---

## BUYER JOURNEY

### Step 1: Browse/Search (Optional Account)
- Buyer can browse boats without account (public access)
- Can search by filters: manufacturer, yacht type, price, length, year, location, etc.
- Can view boat details, images, specifications

### Step 2: Account Creation (Optional but Recommended)
- Buyer registers with role `"buyer"` (default role)
- Can also browse as guest but email required for inquiries
- Logged-in buyers have access to:
  - Saved favorites
  - Price alerts
  - Inquiry history
  - Saved searches

### Step 3: View Boat Details
- Buyer navigates to boat detail page
- Views all boat information, images, specifications
- Can favorite boat (if logged in)
- Can set price alert (if logged in)
- Can share boat listing

### Step 4: Send Inquiry
- Buyer clicks "Contact Seller" or fills inquiry form on boat detail page
- **Required Information:**
  - `boat_id` (automatically set)
  - `message` (required)
  - `email` (required if guest, auto-filled if logged in)
  - `name` (optional if logged in, uses user's name)
  - `phone` (optional)
- System creates inquiry record:
  - `sender_id` = buyer's user ID (if logged in) or `NULL` (if guest)
  - `receiver_id` = seller's user ID (boat owner)
  - `sender_name`, `sender_email`, `sender_phone` = buyer contact info
  - `buyer_name`, `buyer_email`, `buyer_phone` = same as sender (duplicated for schema)
  - `status` = `"unread"` (default)
- Boat's `inquiries_count` increments automatically
- Buyer receives confirmation: "Your inquiry has been sent! A broker will contact you soon."

### Step 5: Track Inquiry
- Buyer views inquiry in dashboard under "Inquiries" → "Sent" tab
- Can see inquiry status: `"unread"`, `"read"`, `"replied"`, `"archived"`
- Can view original message and all replies in conversation thread
- Can see boat details linked to inquiry

### Step 6: Receive Seller Response
- When seller replies, new message appears in conversation thread
- Buyer can see seller's response in inquiry details
- Conversation continues through message thread
- No email notifications implemented (system only tracks status)

### Step 7: Continue Conversation
- Buyer and seller exchange messages within the inquiry thread
- Each message is stored in `messages` table with `inquiry_id` reference
- Messages are ordered chronologically
- Both parties can view full conversation history

### Step 8: Deal Completion (Buyer Perspective)
- **No buyer action required for deal completion in system**
- Deal completion happens outside system (negotiation, payment, transfer)
- Buyer may see boat status change to `"sold"` if they revisit listing
- No explicit "purchase" or "offer" functionality exists

---

## ADMIN ROLE AND ACTIONS

### Boat Listing Management

#### Approve/Reject Listings
- Admin views all boats in admin panel → "Boat Management"
- Filters by status: `"draft"`, `"pending"`, `"active"`, `"sold"`, `"archived"`
- **For `"pending"` boats:**
  - Admin can approve: Change status to `"active"` (makes boat visible)
  - Admin can reject: Change status to `"archived"` (removes from listings)
  - Admin must provide reason (optional but recommended)
  - Action is logged in audit trail

#### Status Management
- Admin can change any boat's status to any valid status:
  - `"draft"` - Hidden, work in progress
  - `"pending"` - Awaiting approval
  - `"active"` - Live and searchable
  - `"sold"` - Deal completed
  - `"archived"` - Removed/ended
- Status changes are logged with:
  - `status_change_reason` (admin-provided reason)
  - `status_changed_by` (admin user ID)
  - `status_changed_at` (timestamp)
  - Audit log entry

#### Delete Boats
- Admin can soft delete (sets `deleted_at` timestamp, can be restored)
- Admin can hard delete (permanent removal from database)
- Hard delete requires reason
- All deletions are logged in audit trail

### Inquiry Management

#### View All Inquiries
- Admin can view all inquiries across platform
- Filter by status: `"unread"`, `"read"`, `"replied"`, `"archived"`
- Search by email, boat title, sender/receiver
- See inquiry details: boat, buyer, seller, messages, timestamps

#### Add Admin Notes
- Admin can add internal notes to inquiries (not visible to buyer/seller)
- Notes stored in `inquiry_admin_notes` table
- Useful for tracking deal progress, issues, or internal communications
- Notes include admin ID and timestamp

#### Bulk Actions
- Admin can bulk archive inquiries
- Admin can view inquiry analytics

### User Management
- Admin can view all users (buyers, sellers, admins)
- Admin can change user roles
- Admin can activate/deactivate user accounts
- Admin can view user statistics (boats count, inquiries count)

### Analytics & Monitoring
- Admin dashboard shows:
  - Total users, boats, inquiries, favorites
  - Boats by status breakdown
  - Pending boats count
  - Average listing price
  - Recent user registrations
- Admin can view analytics over time (users, boats, inquiries by day/week/month)

---

## HOW A DEAL STARTS

### Trigger: Buyer Inquiry
1. **Buyer discovers boat** through:
   - Homepage search
   - Browse/search page
   - Featured yachts section
   - Direct link

2. **Buyer views boat details** (public page, no login required)

3. **Buyer sends inquiry:**
   - Fills inquiry form with message
   - Provides contact info (email required, name/phone optional)
   - Submits inquiry

4. **System creates inquiry:**
   - Links buyer to seller via `inquiry` record
   - Sets `receiver_id` = boat owner (seller)
   - Sets `sender_id` = buyer (if logged in) or `NULL` (if guest)
   - Stores buyer contact information
   - Sets status to `"unread"`
   - Increments boat's `inquiries_count`

5. **Seller receives inquiry:**
   - Appears in seller's dashboard under "Received" inquiries
   - Status shows as `"unread"` until seller views it

**Note:** There is no "make offer" or "request viewing" functionality - all communication starts with a free-form inquiry message.

---

## HOW A DEAL PROGRESSES

### Phase 1: Initial Contact
- Buyer sends inquiry with initial message
- Inquiry status: `"unread"`
- Seller views inquiry (status changes to `"read"`)

### Phase 2: Seller Response
- Seller replies via message thread
- Reply creates new `message` record linked to `inquiry_id`
- Inquiry status changes to `"replied"`
- Buyer can view reply in their "Sent" inquiries

### Phase 3: Conversation Thread
- Buyer and seller exchange messages within the inquiry
- Each message stored in `messages` table
- Messages ordered chronologically
- Both parties can view full conversation history
- No limit on number of messages

### Phase 4: Negotiation (Outside System)
- **All negotiation happens outside the YachtX platform**
- System only tracks communication, not:
  - Offers/counter-offers
  - Price negotiations
  - Viewing appointments
  - Contract terms
  - Payment processing

### Phase 5: Admin Monitoring (Optional)
- Admin can view all inquiries
- Admin can add notes for internal tracking
- Admin does not participate in buyer-seller communication (no admin messaging feature)

---

## HOW A DEAL IS COMPLETED (OR CLOSED)

### Completion Method: Manual Status Update

**There is NO automated deal completion workflow.** The system does not track:
- Offers
- Acceptances
- Contracts
- Payments
- Transfers

### Process:

1. **Deal Finalized Outside System**
   - Buyer and seller complete transaction offline
   - Payment, contracts, inspections handled externally

2. **Status Update (Manual)**
   - **Option A: Seller Updates** (if seller has edit permissions for status)
     - Seller changes boat status to `"sold"` in their dashboard
   - **Option B: Admin Updates** (more common)
     - Admin changes boat status to `"sold"` in admin panel
     - Admin provides reason (e.g., "Sold to [buyer name]")
     - Status change logged in audit trail

3. **Boat Status Changes**
   - Status: `"active"` → `"sold"`
   - Boat remains in database but marked as sold
   - Boat may still be visible in search with "Sold" indicator (implementation-dependent)
   - `status_changed_at` timestamp recorded
   - `status_change_reason` stored

4. **Alternative: Archive**
   - If deal falls through or listing ends
   - Status: `"active"` → `"archived"`
   - Boat removed from active listings
   - Can be restored by admin if needed

### What Happens to Inquiry:
- **Inquiry remains in system** with all messages
- Status can be manually archived by buyer or seller
- No automatic closure when boat is marked "sold"
- Admin can view all inquiries for historical records

### Deal Completion Indicators:
- Boat status = `"sold"` (primary indicator)
- `status_changed_at` timestamp
- `status_change_reason` (if provided)
- Audit log entry (if changed by admin)

---

## KEY SYSTEM LIMITATIONS (Based on Current Implementation)

1. **No Offer System:** Buyers cannot make formal offers, only send inquiries
2. **No Payment Processing:** No integration with payment systems
3. **No Contract Management:** No digital contracts or document storage
4. **No Automated Notifications:** No email/SMS notifications for inquiries or replies
5. **No Deal Tracking:** No formal deal stages or workflow automation
6. **No Escrow:** No escrow or transaction management
7. **No Viewing Scheduling:** No calendar or appointment booking
8. **No Price Negotiation Tracking:** No offer/counter-offer system
9. **Manual Completion:** Deal completion requires manual status update
10. **No Buyer Verification:** No verification of buyer's ability to purchase

---

## DATA FLOW SUMMARY

```
BUYER                    SYSTEM                    SELLER                    ADMIN
  |                        |                         |                         |
  |--Browse Boats--------->|                         |                         |
  |<--Boat List------------|                         |                         |
  |                        |                         |                         |
  |--View Details--------->|                         |                         |
  |<--Boat Info------------|                         |                         |
  |                        |                         |                         |
  |--Send Inquiry--------->|--Create Inquiry-------->|                         |
  |                        |  (status: unread)       |                         |
  |                        |                         |--View Inquiry---------->|
  |                        |                         |  (status: read)          |
  |                        |                         |                         |
  |                        |                         |--Reply----------------->|
  |                        |--Add Message------------|                         |
  |                        |  (status: replied)      |                         |
  |<--Message Thread-------|                         |                         |
  |                        |                         |                         |
  |--Continue Conversation>|--Add Messages---------->|                         |
  |                        |                         |                         |
  |                        |                         |                         |
  |                        |                         |--Deal Finalized-------->|
  |                        |                         |  (outside system)        |
  |                        |                         |                         |
  |                        |<--Update Status---------|                         |
  |                        |  (to "sold")            |                         |
  |                        |                         |                         |
  |                        |<--Update Status---------|                         |
  |                        |  (to "sold")            |                         |
  |                        |                         |                         |
  |<--Boat Status Updated--|                         |                         |
```

---

## DATABASE ENTITIES INVOLVED

1. **`users`** - Buyers, Sellers, Admins
2. **`boats`** - Listings with status (`draft`, `pending`, `active`, `sold`, `archived`)
3. **`inquiries`** - Initial buyer-seller contact (status: `unread`, `read`, `replied`, `archived`)
4. **`messages`** - Conversation thread within inquiries
5. **`inquiry_admin_notes`** - Admin internal notes (not visible to parties)
6. **`audit_logs`** - Admin actions (status changes, deletions, etc.)

---

## CONCLUSION

The YachtX system facilitates **initial contact and communication** between buyers and sellers through inquiries and messages. However, the actual deal negotiation, payment, and completion happen **outside the platform**. The system's role is primarily:

1. **Discovery:** Help buyers find boats
2. **Contact:** Enable initial inquiry
3. **Communication:** Provide message thread for ongoing conversation
4. **Status Tracking:** Mark boats as sold when deals complete (manually)

The system does **not** handle:
- Offers/negotiations
- Payments
- Contracts
- Automated deal workflows
- Transaction management

Deal completion is indicated solely by changing the boat status to `"sold"` manually (by admin or seller).
