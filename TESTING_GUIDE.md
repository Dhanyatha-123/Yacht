# Testing Guide: Login & Signup in Chrome

This guide will help you test all test accounts in Chrome browser.

## Prerequisites

1. **Start Backend Server**
   ```bash
   cd backend
   npm run dev
   ```
   Backend should run on `http://localhost:3000` (or check your `.env`)

2. **Start Frontend Server**
   ```bash
   cd frontend
   npm run dev
   ```
   Frontend should run on `http://localhost:5173`

3. **Verify Database**
   - Make sure PostgreSQL is running
   - Verify seed data is loaded:
     ```sql
     SELECT email, username, role, is_active FROM users;
     ```

## Step 1: Verify Password Hashes

Before testing in browser, verify all password hashes are correct:

```bash
node test-accounts.js
```

This will verify that all bcrypt hashes match the password `Test123!`

## Step 2: Test Login in Chrome

### Open Chrome
Navigate to: `http://localhost:5173/login`

### Test Each Account

Use the following credentials for each account:

#### Admin Accounts
| Email | Password | Expected Result |
|-------|----------|-----------------|
| `admin@yachtx.com` | `Test123!` | ✅ Should login, redirect to dashboard/admin |
| `admin2@yachtx.com` | `Test123!` | ✅ Should login, redirect to dashboard/admin |

#### Seller Accounts
| Email | Password | Expected Result |
|-------|----------|-----------------|
| `seller@yachtx.com` | `Test123!` | ✅ Should login, redirect to dashboard |
| `seller2@yachtx.com` | `Test123!` | ✅ Should login, redirect to dashboard |
| `seller3@yachtx.com` | `Test123!` | ✅ Should login, redirect to dashboard |
| `seller4@yachtx.com` | `Test123!` | ✅ Should login, redirect to dashboard |
| `seller5@yachtx.com` | `Test123!` | ❌ Should fail (account inactive) |

#### Buyer Accounts
| Email | Password | Expected Result |
|-------|----------|-----------------|
| `buyer@yachtx.com` | `Test123!` | ✅ Should login, redirect to dashboard |
| `buyer2@yachtx.com` | `Test123!` | ✅ Should login, redirect to dashboard |
| `buyer3@yachtx.com` | `Test123!` | ✅ Should login, redirect to dashboard |
| `buyer4@yachtx.com` | `Test123!` | ❌ Should fail (account inactive) |
| `test@yachtx.com` | `Test123!` | ✅ Should login, redirect to dashboard |

### Testing Checklist

For each account, verify:

- [ ] Login form accepts email and password
- [ ] Login button is clickable
- [ ] After successful login:
  - [ ] Redirects to correct page (dashboard/admin)
  - [ ] User menu shows correct name
  - [ ] User role is correct
  - [ ] No error messages appear
- [ ] After failed login:
  - [ ] Error message displays correctly
  - [ ] Form doesn't submit
  - [ ] User stays on login page

## Step 3: Test Signup/Registration

### Navigate to Signup
Go to: `http://localhost:5173/register`

### Test New Account Creation

Try creating accounts with different roles:

#### Test Case 1: Create New Seller Account
- **Email**: `newtest@yachtx.com`
- **Password**: `Test123!`
- **Confirm Password**: `Test123!`
- **Role**: Select "Boat Seller"
- **Username**: `newtestuser`
- **First Name**: `New`
- **Last Name**: `Test`
- **Expected**: ✅ Account created, redirected to homepage or dashboard

#### Test Case 2: Create New Buyer Account
- **Email**: `newbuyer@yachtx.com`
- **Password**: `Test123!`
- **Confirm Password**: `Test123!`
- **Role**: Select "Buyer"
- **Expected**: ✅ Account created

#### Test Case 3: Test Validation
- **Email mismatch**: Enter different emails in email and confirm email
  - **Expected**: ❌ Error: "Email addresses do not match"
- **Password mismatch**: Enter different passwords
  - **Expected**: ❌ Error: "Passwords do not match"
- **Weak password**: Enter `12345`
  - **Expected**: ❌ Error: "Password is too weak"
- **Missing role**: Don't select a role
  - **Expected**: ❌ Error: "Please select how you intend to use YachtX"

#### Test Case 4: Duplicate Email
- Try to register with existing email: `admin@yachtx.com`
- **Expected**: ❌ Error: "Email already exists" or similar

### Signup Checklist

- [ ] Form validates all required fields
- [ ] Password strength indicator works
- [ ] Email confirmation works
- [ ] Password confirmation works
- [ ] Role selection is required
- [ ] Successful registration redirects correctly
- [ ] Error messages display appropriately
- [ ] Duplicate email is rejected

## Step 4: Test Edge Cases

### Test Inactive Accounts
1. Try logging in with `seller5@yachtx.com` / `Test123!`
   - **Expected**: ❌ Error: "Account is deactivated"

2. Try logging in with `buyer4@yachtx.com` / `Test123!`
   - **Expected**: ❌ Error: "Account is deactivated"

### Test Invalid Credentials
1. Wrong password: `admin@yachtx.com` / `WrongPassword123!`
   - **Expected**: ❌ Error: "Invalid credentials"

2. Non-existent email: `nonexistent@yachtx.com` / `Test123!`
   - **Expected**: ❌ Error: "Invalid credentials"

3. Empty fields:
   - **Expected**: ❌ Form validation prevents submission

## Step 5: Browser Console Check

Open Chrome DevTools (F12) and check:

1. **Network Tab**: Verify API calls are successful
   - Login: `POST /api/auth/login` should return 200
   - Register: `POST /api/auth/register` should return 201

2. **Console Tab**: Check for JavaScript errors
   - Should see no red errors
   - Check for authentication token storage

3. **Application Tab**: Verify token storage
   - Check localStorage or sessionStorage for JWT token

## Troubleshooting

### Login Fails for All Accounts
- Check backend server is running
- Check database connection
- Verify seed data is loaded
- Check backend logs for errors

### Password Hash Mismatch
- Run `node test-accounts.js` to verify hashes
- Check if bcrypt library version matches
- Verify seed.sql password hash is correct

### CORS Errors
- Check backend CORS configuration
- Verify frontend URL is allowed in backend

### Token Issues
- Check JWT_SECRET is set in backend `.env`
- Verify token expiration settings
- Check token storage in browser

## Quick Test Script

You can also use this quick test in browser console (after page loads):

```javascript
// Test login API directly
fetch('http://localhost:3000/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    email: 'admin@yachtx.com',
    password: 'Test123!'
  })
})
.then(r => r.json())
.then(data => console.log('Login Result:', data))
.catch(err => console.error('Error:', err));
```

## Expected Results Summary

- **Total Accounts**: 12
- **Should Login Successfully**: 10 (2 admins, 4 active sellers, 4 active buyers)
- **Should Fail Login**: 2 (inactive accounts: seller5, buyer4)
- **Signup**: Should work for new unique emails

---

**Last Updated**: Based on seed files in `database/` directory
