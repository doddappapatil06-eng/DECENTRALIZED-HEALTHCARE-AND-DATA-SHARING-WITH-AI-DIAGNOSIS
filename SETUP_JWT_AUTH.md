# CareAI JWT Authentication System - Complete Setup Guide

## 📋 Backend Setup

### Step 1: Install JWT Package
```bash
cd backend
pip install -r requirements.txt
```

### Step 2: Apply Migrations
```bash
python manage.py makemigrations
python manage.py migrate
```

### Step 3: Create Superuser (Optional - for Django Admin)
```bash
python manage.py createsuperuser
```

### Step 4: Run Development Server
```bash
python manage.py runserver
```

Server will be available at: `http://127.0.0.1:8000`

---

## 🎨 Frontend Setup

### Step 1: Install Dependencies
```bash
cd frontend
npm install
```

### Step 2: Run Development Server
```bash
npm run dev
```

Server will be available at: `http://127.0.0.1:5173` (default Vite port)

---

## 🔐 Authentication Endpoints

### Register
**POST** `/api/auth/register/`

Request:
```json
{
  "email": "doctor@example.com",
  "name": "Dr. John Doe",
  "password": "password123",
  "password_confirm": "password123",
  "role": "doctor"
}
```

Response:
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "email": "doctor@example.com",
    "name": "Dr. John Doe",
    "role": "doctor",
    "created_at": "2024-04-29T10:00:00Z"
  }
}
```

---

### Login
**POST** `/api/auth/login/`

Request:
```json
{
  "email": "doctor@example.com",
  "password": "password123"
}
```

Response:
```json
{
  "message": "Login successful",
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "email": "doctor@example.com",
    "name": "Dr. John Doe",
    "role": "doctor",
    "created_at": "2024-04-29T10:00:00Z"
  },
  "role": "doctor"
}
```

---

### Get Profile
**GET** `/api/auth/profile/` (Requires JWT Token)

Response:
```json
{
  "user": {
    "id": 1,
    "email": "doctor@example.com",
    "name": "Dr. John Dome",
    "role": "doctor",
    "created_at": "2024-04-29T10:00:00Z"
  },
  "role": "doctor"
}
```

---

### Update Profile
**PUT** `/api/auth/profile/` (Requires JWT Token)

Request:
```json
{
  "name": "Dr. Jane Doe"
}
```

Response:
```json
{
  "message": "Profile updated successfully",
  "user": {
    "id": 1,
    "email": "doctor@example.com",
    "name": "Dr. Jane Doe",
    "role": "doctor",
    "created_at": "2024-04-29T10:00:00Z"
  }
}
```

---

### Refresh Token
**POST** `/api/auth/refresh/`

Request:
```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

Response:
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

---

### Logout
**POST** `/api/auth/logout/` (Requires JWT Token)

Response:
```json
{
  "message": "Logout successful"
}
```

---

## 🔑 Using JWT Tokens

### How to Use Tokens in Frontend

1. **Store tokens after login:**
```javascript
localStorage.setItem("access_token", access);
localStorage.setItem("refresh_token", refresh);
localStorage.setItem("user_role", role);
```

2. **Attach token to API requests (automatic via api.js):**
```
Authorization: Bearer <access_token>
```

3. **Token refresh automatically handled** by api.js interceptor

---

## 🛡️ Protected Routes

### Frontend Routes

| Route | Role | Status |
|-------|------|--------|
| `/login` | Public | ✅ |
| `/register` | Public | ✅ |
| `/hospital` | hospital | 🔒 |
| `/doctor` | doctor | 🔒 |
| `/unauthorized` | All | ✅ |

---

### Backend Protected Endpoints

All the following endpoints now require JWT authentication:

- POST `/api/patients/create/` - Create patient (Any authenticated user)
- POST `/api/records/upload-report/` - Upload report (Any authenticated user)
- GET `/api/records/get-records/` - Get records (Any authenticated user)
- POST `/api/predict/` - Predict diabetes (Any authenticated user)
- POST `/api/blockchain/store-hash/` - Store hash on blockchain (Any authenticated user)

---

## 🛠️ Environment Variables (.env)

### Backend (.env in `backend/` folder)

```env
DJANGO_SECRET_KEY=your-secret-key-here
DJANGO_DEBUG=True
DJANGO_ALLOWED_HOSTS=127.0.0.1,localhost
CORS_ALLOWED_ORIGINS=http://127.0.0.1:5173,http://localhost:5173
IPFS_GATEWAY=https://gateway.pinata.cloud/ipfs/
OTP_EXPIRY_MINUTES=5
```

### Frontend (.env.local in `frontend/` folder)

```env
VITE_API_BASE_URL=http://127.0.0.1:8000
```

---

## 🧪 Test the System

### 1. Register a New User (Hospital)
```bash
curl -X POST http://127.0.0.1:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "hospital@example.com",
    "name": "City Hospital",
    "password": "password123",
    "password_confirm": "password123",
    "role": "hospital"
  }'
```

### 2. Login
```bash
curl -X POST http://127.0.0.1:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "hospital@example.com",
    "password": "password123"
  }'
```

### 3. Use Access Token
```bash
curl -X GET http://127.0.0.1:8000/api/auth/profile/ \
  -H "Authorization: Bearer <access_token>"
```

---

## 📊 User Roles

### Doctor
- Can view personal profile
- Can predict diabetes
- Can access patient records (with OTP verification)
- Can upload reports

### Hospital
- Can view personal profile
- Can manage patient information
- Can view patient records
- Can upload reports

### Admin (Superuser)
- Full access to Django Admin Panel (`/admin/`)
- Can manage all users and data

---

## 🔄 Token Lifecycle

1. **Login** → Receive both access & refresh tokens
2. **Access Token Expires** (1 hour) → API returns 401
3. **Automatic Refresh** → api.js sends refresh token
4. **Get New Access Token** → Continue using API
5. **Refresh Token Expires** (7 days) → User must login again

---

## ⚙️ JWT Configuration Details

Default JWT settings in `settings.py`:

- **Access Token Lifetime:** 1 hour
- **Refresh Token Lifetime:** 7 days
- **Algorithm:** HS256
- **Signing Key:** Django SECRET_KEY

To modify these, edit `SIMPLE_JWT` settings in `backend/careai/settings.py`

---

## 🐛 Troubleshooting

### Issue: "Token is invalid or expired"
**Solution:** Clear localStorage and login again
```javascript
localStorage.clear();
window.location.href = "/login";
```

### Issue: CORS errors
**Solution:** Ensure frontend URL is in `CORS_ALLOWED_ORIGINS` in `.env`

### Issue: Migration errors
**Solution:** Run:
```bash
python manage.py makemigrations --empty auth --name fix_migration
python manage.py migrate
```

### Issue: "No CustomUser in database"
**Solution:** Make sure `AUTH_USER_MODEL = "auth.CustomUser"` is set in `settings.py`

---

## 📚 File Structure

### Backend
```
backend/
├── auth/                    # NEW - Auth app
│   ├── models.py           # CustomUser model
│   ├── serializers.py      # Auth serializers
│   ├── views.py            # Auth endpoints
│   ├── urls.py             # Auth URLs
│   ├── admin.py            # Admin panel config
│   └── migrations/         # Database migrations
├── careai/
│   ├── settings.py         # UPDATED - JWT config
│   └── urls.py             # UPDATED - Auth URLs
├── patients/
│   └── views.py            # UPDATED - JWT protection
├── records/
│   └── views.py            # UPDATED - JWT protection
├── ai/
│   └── views.py            # UPDATED - JWT protection
├── blockchain/
│   └── views.py            # UPDATED - JWT protection
└── requirements.txt        # UPDATED - Added JWT package
```

### Frontend
```
frontend/
├── src/
│   ├── pages/
│   │   ├── Login.jsx       # NEW - Login page
│   │   ├── Register.jsx    # NEW - Register page
│   │   └── Unauthorized.jsx # NEW - 403 page
│   ├── components/
│   │   └── ProtectedRoute.jsx # NEW - Route guard
│   ├── App.jsx             # UPDATED - React Router setup
│   ├── api.js              # UPDATED - JWT interceptor
│   ├── styles.css          # UPDATED - Auth styles
│   └── main.jsx
├── package.json            # UPDATED - Added react-router-dom
└── vite.config.js
```

---

## ✅ Complete Implementation Checklist

- ✅ JWT package installed
- ✅ Custom user model created
- ✅ Auth endpoints implemented
- ✅ JWT token refresh logic implemented
- ✅ All existing endpoints protected
- ✅ Frontend login/register pages created
- ✅ Protected route component created
- ✅ JWT interceptor in api.js
- ✅ React Router setup
- ✅ Role-based routing
- ✅ Automatic token refresh
- ✅ Logout functionality
- ✅ Responsive design
- ✅ Error handling

---

## 🚀 Next Steps

1. Run backend migrations: `python manage.py migrate`
2. Install frontend dependencies: `npm install`
3. Start development servers
4. Test login/register flow
5. Test protected endpoints
6. Test role-based access
7. Deploy to production with proper HTTPS
