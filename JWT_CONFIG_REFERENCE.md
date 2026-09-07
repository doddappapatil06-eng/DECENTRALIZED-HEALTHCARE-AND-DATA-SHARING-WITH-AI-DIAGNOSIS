# JWT Configuration Reference for CareAI

## 📋 Backend Configuration (settings.py)

### Custom User Model
```python
AUTH_USER_MODEL = "auth.CustomUser"
```
This tells Django to use the CustomUser model from the auth app instead of the default User model.

---

### SIMPLE_JWT Settings

```python
SIMPLE_JWT = {
    # Token Lifetimes
    "ACCESS_TOKEN_LIFETIME": timedelta(hours=1),      # 1 hour
    "REFRESH_TOKEN_LIFETIME": timedelta(days=7),      # 7 days
    
    # Token Rotation
    "ROTATE_REFRESH_TOKENS": False,                   # Don't create new refresh token on refresh
    "BLACKLIST_AFTER_ROTATION": False,                # Don't blacklist old tokens
    "UPDATE_LAST_LOGIN": False,                       # Don't update last_login field
    
    # Token Signing
    "ALGORITHM": "HS256",                             # HMAC with SHA-256
    "SIGNING_KEY": SECRET_KEY,                        # Use Django SECRET_KEY
    "VERIFYING_KEY": None,                            # Not needed for symmetric signing
    
    # Token Claims
    "AUDIENCE": None,
    "ISSUER": None,
    "JTI_CLAIM": "jti",                              # JWT ID claim name
    "TOKEN_TYPE_CLAIM": "token_type",
    "JTI_IN_BLACKLIST_CLAIM": "blacklist",
    
    # User Association
    "TOKEN_USER_CLASS": "auth.models.CustomUser",
    "AUTH_TOKEN_CLASSES": ("rest_framework_simplejwt.tokens.AccessToken",),
    "AUTH_HEADER_TYPES": ("Bearer",),                 # Use "Bearer <token>"
    "AUTH_HEADER_NAME": "HTTP_AUTHORIZATION",
    "USER_ID_FIELD": "id",                            # User field for token
    "USER_ID_CLAIM": "user_id",                       # Claim name in token
    
    # Serializer Classes
    "TOKEN_OBTAIN_SERIALIZER": "rest_framework_simplejwt.serializers.TokenObtainPairSerializer",
    "TOKEN_REFRESH_SERIALIZER": "rest_framework_simplejwt.serializers.TokenRefreshSerializer",
    "TOKEN_VERIFY_SERIALIZER": "rest_framework_simplejwt.serializers.TokenVerifySerializer",
    "TOKEN_BLACKLIST_SERIALIZER": "rest_framework_simplejwt.serializers.TokenBlacklistSerializer",
    "SLIDING_TOKEN_OBTAIN_SERIALIZER": "rest_framework_simplejwt.serializers.TokenObtainSlidingSerializer",
    "SLIDING_TOKEN_REFRESH_SERIALIZER": "rest_framework_simplejwt.serializers.TokenRefreshSlidingSerializer",
}
```

---

### REST Framework Configuration

```python
REST_FRAMEWORK = {
    # Renderers
    "DEFAULT_RENDERER_CLASSES": [
        "rest_framework.renderers.JSONRenderer",
    ],
    
    # Parsers
    "DEFAULT_PARSER_CLASSES": [
        "rest_framework.parsers.JSONParser",
        "rest_framework.parsers.FormParser",
        "rest_framework.parsers.MultiPartParser",
    ],
    
    # Authentication
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ],
    
    # Permissions
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.IsAuthenticated",      # Require auth by default
    ],
}
```

---

### INSTALLED_APPS Update

```python
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "corsheaders",
    "rest_framework",
    "rest_framework_simplejwt",      # NEW - JWT support
    "auth",                           # NEW - Custom auth app
    "patients",
    "records",
    "otp",
    "ai",
    "blockchain",
]
```

---

## 🎨 Frontend Configuration (api.js)

### Request Interceptor
```javascript
api.interceptors.request.use((config) => {
  const token = localStorage.getItem("access_token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```
Automatically attaches JWT token to all API requests.

---

### Response Interceptor
```javascript
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    // Handle 401 Unauthorized
    if (error.response?.status === 401) {
      const refreshToken = localStorage.getItem("refresh_token");
      if (refreshToken) {
        // Attempt token refresh
        const response = await axios.post(
          `/api/auth/refresh/`,
          { refresh: refreshToken }
        );
        localStorage.setItem("access_token", response.data.access);
        // Retry original request
        return api(error.config);
      } else {
        // No refresh token, redirect to login
        localStorage.clear();
        window.location.href = "/login";
      }
    }
    return Promise.reject(error);
  }
);
```
Handles token refresh automatically when access token expires.

---

## 📊 Token Structure

### Access Token Payload
```json
{
  "token_type": "access",
  "exp": 1640000000,           # Expiration time (1 hour from now)
  "iat": 1639996400,           # Issued at time
  "jti": "abc123...",          # JWT ID (unique identifier)
  "user_id": 1                 # User ID
}
```

### Refresh Token Payload
```json
{
  "token_type": "refresh",
  "exp": 1647000000,          # Expiration time (7 days from now)
  "iat": 1639996400,          # Issued at time
  "jti": "def456..."          # JWT ID
}
```

---

## 🔐 Custom User Model Fields

```python
# Primary key
id = models.AutoField(primary_key=True)

# Authentication
email = models.EmailField(max_length=255, unique=True)     # Username field
password = models.CharField(max_length=128)                # Hashed password
name = models.CharField(max_length=255)

# Authorization
role = models.CharField(
    max_length=50,
    choices=[
        ("doctor", "Doctor"),
        ("hospital", "Hospital"),
        ("admin", "Admin"),
    ],
    default="doctor"
)

# Status
is_active = models.BooleanField(default=True)              # Can login?
is_admin = models.BooleanField(default=False)              # Is superuser?

# Timestamps
created_at = models.DateTimeField(auto_now_add=True)       # Account creation
updated_at = models.DateTimeField(auto_now=True)           # Last update
```

---

## 📝 Auth Endpoints Details

### POST /api/auth/register/

**Purpose:** Create new user account

**Request Body:**
```json
{
  "email": "string (required, unique)",
  "name": "string (required)",
  "password": "string (required, min 6 chars)",
  "password_confirm": "string (required, must match password)",
  "role": "string (required: 'doctor' or 'hospital')"
}
```

**Success Response (201 Created):**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "email": "doctor@example.com",
    "name": "Dr. Smith",
    "role": "doctor",
    "created_at": "2024-04-29T10:00:00Z"
  }
}
```

**Error Response (400 Bad Request):**
```json
{
  "email": ["User with this email already exists"]
}
```

---

### POST /api/auth/login/

**Purpose:** Authenticate user and get tokens

**Request Body:**
```json
{
  "email": "string (required)",
  "password": "string (required)"
}
```

**Success Response (200 OK):**
```json
{
  "message": "Login successful",
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "email": "doctor@example.com",
    "name": "Dr. Smith",
    "role": "doctor",
    "created_at": "2024-04-29T10:00:00Z"
  },
  "role": "doctor"
}
```

**Error Response (400 Bad Request):**
```json
{
  "non_field_errors": ["Invalid email or password."]
}
```

---

### GET /api/auth/profile/

**Purpose:** Get current user's profile

**Headers Required:**
```
Authorization: Bearer <access_token>
```

**Success Response (200 OK):**
```json
{
  "user": {
    "id": 1,
    "email": "doctor@example.com",
    "name": "Dr. Smith",
    "role": "doctor",
    "created_at": "2024-04-29T10:00:00Z"
  },
  "role": "doctor"
}
```

**Error Response (401 Unauthorized):**
```json
{
  "detail": "Authentication credentials were not provided."
}
```

---

### PUT /api/auth/profile/

**Purpose:** Update current user's profile

**Headers Required:**
```
Authorization: Bearer <access_token>
```

**Request Body (all optional):**
```json
{
  "name": "Dr. Jane Smith"
}
```

**Success Response (200 OK):**
```json
{
  "message": "Profile updated successfully",
  "user": {
    "id": 1,
    "email": "doctor@example.com",
    "name": "Dr. Jane Smith",
    "role": "doctor",
    "created_at": "2024-04-29T10:00:00Z"
  }
}
```

---

### POST /api/auth/refresh/

**Purpose:** Get new access token using refresh token

**Request Body:**
```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

**Success Response (200 OK):**
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

**Error Response (400 Bad Request):**
```json
{
  "detail": "Token is invalid or expired"
}
```

---

### POST /api/auth/logout/

**Purpose:** Logout user (mainly for client-side token cleanup)

**Headers Required:**
```
Authorization: Bearer <access_token>
```

**Success Response (200 OK):**
```json
{
  "message": "Logout successful"
}
```

---

## 🛡️ Authentication Flow Diagram

```
1. User Registration
   Register Form → POST /api/auth/register/ → Database → Success/Error

2. User Login
   Login Form → POST /api/auth/login/ → Validate credentials → 
   Generate tokens → Store in localStorage → Redirect

3. API Request with Token
   Frontend API Call → Attach Bearer Token → Backend validates JWT → 
   Process request → Return data

4. Token Expiration
   Access token expires after 1 hour → 
   Frontend gets 401 → Automatically use refresh token → 
   POST /api/auth/refresh/ → Get new access token → Retry request

5. Logout
   User clicks logout → Clear localStorage → Redirect to /login
```

---

## ⚙️ Customization Guide

### Change Token Lifetimes
Edit in `backend/careai/settings.py`:
```python
SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(hours=2),    # 2 hours
    "REFRESH_TOKEN_LIFETIME": timedelta(days=30),   # 30 days
}
```

### Change Default Permission
Edit in `backend/careai/settings.py`:
```python
REST_FRAMEWORK = {
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.AllowAny",      # Allow unauthenticated
    ],
}
```

### Add Custom User Fields
Edit `backend/auth/models.py`:
```python
class CustomUser(AbstractBaseUser):
    # Add your custom fields here
    phone = models.CharField(max_length=20, blank=True)
    department = models.CharField(max_length=100, blank=True)
```

Then run:
```bash
python manage.py makemigrations
python manage.py migrate
```

---

## 🧪 Testing with cURL

### Register
```bash
curl -X POST http://localhost:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "name": "Test User",
    "password": "TestPass123",
    "password_confirm": "TestPass123",
    "role": "doctor"
  }'
```

### Login
```bash
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPass123"
  }'
```

### Use Token
```bash
curl -X GET http://localhost:8000/api/auth/profile/ \
  -H "Authorization: Bearer <your_access_token_here>"
```

### Refresh Token
```bash
curl -X POST http://localhost:8000/api/auth/refresh/ \
  -H "Content-Type: application/json" \
  -d '{
    "refresh": "<your_refresh_token_here>"
  }'
```

---

## 📚 References

- [Simple JWT Documentation](https://django-rest-framework-simplejwt.readthedocs.io/)
- [Django REST Framework Authentication](https://www.django-rest-framework.org/api-guide/authentication/)
- [JWT.IO](https://jwt.io/)
- [React Router Documentation](https://reactrouter.com/)
