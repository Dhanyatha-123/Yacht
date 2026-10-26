# YachtX Test Accounts

> ⚠️ **SECURITY WARNING**: These are TEST accounts for development purposes only.  
> **DO NOT** use these credentials in production environments.  
> **DO NOT** commit this file to version control if it contains production credentials.

---

## Default Password

All test accounts use the same password:
```
Test123!
```

---

## Admin Accounts

| ID | Email | Username | Name | Phone | Role | Status |
|----|-------|----------|------|-------|------|--------|
| `7` | `admin@yachtx.com` | admin | Admin User | 443-888-9190 | admin | Active |
| `19` | `admin2@yachtx.com` | admin2 | Secondary Admin | 555-111-2222 | admin | Active |

---

## Seller Accounts

| ID | Email | Username | Name | Phone | Role | Status |
|----|-------|----------|------|-------|------|--------|
| `8` | `seller@yachtx.com` | johnseller | John Smith | 555-123-4567 | seller | Active |
| `9` | `seller2@yachtx.com` | maryseller | Mary Johnson | 555-234-5678 | seller | Active |
| `13` | `seller3@yachtx.com` | davidseller | David Brown | 555-567-8901 | seller | Active |
| `14` | `seller4@yachtx.com` | sarahseller | Sarah Davis | 555-678-9012 | seller | Active |
| `15` | `seller5@yachtx.com` | mikeseller | Mike Wilson | 555-789-0123 | seller | **Inactive** |
| `40` | `lescinq@yachtx.com` | lescinq_holdings | Les Cinq Holdings | +377 99 99 99 99 | seller | Active |

---

## Buyer Accounts

| ID | Email | Username | Name | Phone | Role | Status |
|----|-------|----------|------|-------|------|--------|
| `10` | `buyer@yachtx.com` | bobbuyer | Bob Williams | 555-345-6789 | buyer | Active |
| `11` | `test@yachtx.com` | testuser | Test User | 555-456-7890 | buyer | Active |
| `16` | `buyer2@yachtx.com` | alicebuyer | Alice Martinez | 555-890-1234 | buyer | Active |
| `17` | `buyer3@yachtx.com` | charliebuyer | Charlie Anderson | 555-901-2345 | buyer | Active |
| `18` | `buyer4@yachtx.com` | dianabuyer | Diana Taylor | 555-012-3456 | buyer | **Inactive** |

---

## Quick Reference

### Most Common Test Accounts

- **Admin**: `admin@yachtx.com` / `Test123!` (ID: 7)
- **Seller**: `seller@yachtx.com` / `Test123!` (ID: 8)
- **Buyer**: `buyer@yachtx.com` / `Test123!` (ID: 10)
- **Test User**: `test@yachtx.com` / `Test123!` (ID: 11)
- **Les Cinq** (Superyacht Seller): `lescinq@yachtx.com` / `Test123!` (ID: 40)

---

## Account Summary

- **Total Accounts**: 13
- **Admins**: 2
- **Sellers**: 6 (5 active, 1 inactive)
- **Buyers**: 5 (4 active, 1 inactive)

---

## Notes

- All accounts have `email_verified` set to `true`
- Password hash: `$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG` (bcrypt, cost factor 12)
- These accounts are created by running `database/seed.sql` and `database/seed_admin_test.sql`
- Inactive accounts can be used to test account status filtering and management features
- User IDs are assigned by the database and may vary between installations

### Les Cinq Holdings (Special Seller Account)

This account is pre-configured for demonstrating the superyacht listing flow:
- **Login**: `lescinq@yachtx.com` / `Test123!`
- **Location**: Monaco
- **Purpose**: Premium yacht listing demo (Feadship 75.8m "One" / Les Cinq)
- **Add Boat Form**: Pre-filled with yacht details when navigating to `/dashboard/boats/new`
- **Images**: Place yacht photos in `frontend/public/images/boats/lescinq/`
  - `side-profile.jpg`
  - `bow-view.jpg`
  - `aerial-view.jpg`

---

## Database Setup

To create these accounts, run:

```bash
# Load main seed data
psql -U postgres -d yachtx -f database/seed.sql

# Load additional admin test data
psql -U postgres -d yachtx -f database/seed_admin_test.sql
```

Or use the setup scripts:
- Windows: `database/setup-db.ps1`
- Linux/Mac: `database/setup-db.sh`

---

**Last Updated**: Based on current database state
