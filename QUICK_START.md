# 🚀 CareAI - Quick Start Commands

## Installation & Setup

### Backend Setup
```bash
# Navigate to backend
cd backend

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py makemigrations
python manage.py migrate

# (Optional) Create superuser for admin panel
python manage.py createsuperuser
```

### Frontend Setup
```bash
# Navigate to frontend
cd frontend

# Install dependencies
npm install
```

---

## Starting Development Servers

### Terminal 1: Start Backend
```bash
cd backend
python manage.py runserver
```
**Backend will run at:** `http://127.0.0.1:8000`

### Terminal 2: Start Frontend
```bash
cd frontend
npm run dev
```
**Frontend will run at:** `http://127.0.0.1:5173`

---

## Access Points

| Service | URL | Purpose |
|---------|-----|---------|
| Frontend | http://localhost:5173 | User interface |
| Backend API | http://localhost:8000 | REST API |
| Django Admin | http://localhost:8000/admin | Admin panel |

---

## Test the System

### 1. Open Frontend
```
http://localhost:5173
```

### 2. Register New Account
- Click "Register here"
- Fill in form:
  - Email: `test@example.com`
  - Name: `Test User`
  - Role: `doctor` or `hospital`
  - Password: `TestPass123`
  - Confirm: `TestPass123`
- Submit

### 3. Login
- Use same credentials to login
- Check localStorage for tokens:
  - `access_token`
  - `refresh_token`
  - `user_role`

### 4. Access Protected Routes
- `/doctor` - Doctor dashboard
- `/hospital` - Hospital dashboard
- `/api/auth/profile/` - Your profile

---

## Reset & Start Fresh

### Clear Database
```bash
cd backend
rm db.sqlite3
python manage.py migrate
```

### Clear Frontend Cache
```javascript
// Run in browser console
localStorage.clear()
location.reload()
```

---

## Common Commands

### Run Specific Migrations
```bash
python manage.py makemigrations auth
python manage.py migrate auth
```

### Create New Superuser
```bash
python manage.py createsuperuser
```

### Shell Access
```bash
python manage.py shell
```

### Django Admin
```
http://localhost:8000/admin
Username: (your_superuser_email)
Password: (your_superuser_password)
```

---

## Environment Setup

### Backend (.env in backend/)
```bash
# Create .env file
touch .env

# Add to .env:
DJANGO_SECRET_KEY=django-insecure-change-me
DJANGO_DEBUG=True
DJANGO_ALLOWED_HOSTS=127.0.0.1,localhost
CORS_ALLOWED_ORIGINS=http://127.0.0.1:5173,http://localhost:5173
```

### Frontend (.env.local in frontend/)
```bash
# Create .env.local file
touch .env.local

# Add to .env.local:
VITE_API_BASE_URL=http://127.0.0.1:8000
```

---

## Test API Endpoints with cURL

### Register
```bash
curl -X POST http://localhost:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "doc@test.com",
    "name": "Doctor Test",
    "password": "Test1234",
    "password_confirm": "Test1234",
    "role": "doctor"
  }'
```

### Login
```bash
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "doc@test.com",
    "password": "Test1234"
  }'
```

### Get Profile (Use token from login response)
```bash
curl -X GET http://localhost:8000/api/auth/profile/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE"
```

### Refresh Token
```bash
curl -X POST http://localhost:8000/api/auth/refresh/ \
  -H "Content-Type: application/json" \
  -d '{
    "refresh": "YOUR_REFRESH_TOKEN_HERE"
  }'
```

---

## Troubleshooting

### Issue: "No module named 'rest_framework_simplejwt'"
```bash
# Solution: Install requirements again
pip install -r requirements.txt
```

### Issue: "File not found: db.sqlite3"
```bash
# Solution: Run migrations
python manage.py migrate
```

### Issue: "CORS error"
```bash
# Solution: Check .env and make sure CORS_ALLOWED_ORIGINS includes your frontend URL
# Confirm it's set in backend/careai/settings.py
```

### Issue: "Token invalid"
```bash
# Solution: Clear localStorage and login again
localStorage.clear()
```

### Issue: "Port already in use"
```bash
# Backend on different port:
python manage.py runserver 8001

# Frontend on different port:
npm run dev -- --port 5174
```

---

## Documentation Files

📖 **Full Setup Guide**
```
SETUP_JWT_AUTH.md
```

📖 **Implementation Overview**
```
JWT_IMPLEMENTATION.md
```

📖 **Configuration Reference**
```
JWT_CONFIG_REFERENCE.md
```

📖 **Completion Status**
```
IMPLEMENTATION_COMPLETE.md
```

---

## Quick Checklist

- [ ] Backend dependencies installed
- [ ] Frontend dependencies installed
- [ ] Migrations run
- [ ] .env files configured
- [ ] Backend server running
- [ ] Frontend server running
- [ ] Can register new account
- [ ] Can login
- [ ] Tokens stored in localStorage
- [ ] Redirected to correct dashboard
- [ ] Logout works

---

## Next Steps

1. ✅ Run setup commands above
2. ✅ Test register/login flow
3. ✅ Test protected routes
4. ✅ Read SETUP_JWT_AUTH.md for full details
5. ✅ Deploy to production when ready

---

## Need Help?

| Issue | Solution |
|-------|----------|
| Dependencies not installed | `pip install -r requirements.txt` |
| Database error | `python manage.py migrate` |
| Port in use | Change port in run command |
| Tokens not working | Clear localStorage, restart browser |
| Frontend not connecting | Check VITE_API_BASE_URL in .env.local |

---

**Everything is set up and ready to go!** 🎉
