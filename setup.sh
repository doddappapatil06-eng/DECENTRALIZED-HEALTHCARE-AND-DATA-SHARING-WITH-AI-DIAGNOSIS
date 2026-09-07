#!/bin/bash
# CareAI JWT Authentication System - Quick Setup Script

echo "=========================================="
echo "CareAI JWT Authentication Setup"
echo "=========================================="

# Backend Setup
echo ""
echo "🔧 Setting up Backend..."
cd backend
pip install -r requirements.txt
echo "✅ Backend dependencies installed"

echo ""
echo "🗄️  Running migrations..."
python manage.py makemigrations
python manage.py migrate
echo "✅ Database migrations completed"

echo ""
echo "⚙️  Backend setup complete!"
echo "📍 Backend URL: http://127.0.0.1:8000"

# Frontend Setup
echo ""
echo "🎨 Setting up Frontend..."
cd ../frontend
npm install
echo "✅ Frontend dependencies installed"
echo "⚙️  Frontend setup complete!"
echo "📍 Frontend URL: http://127.0.0.1:5173"

echo ""
echo "=========================================="
echo "✨ Setup Complete!"
echo "=========================================="
echo ""
echo "📝 Next Steps:"
echo "  1. Terminal 1: cd backend && python manage.py runserver"
echo "  2. Terminal 2: cd frontend && npm run dev"
echo "  3. Visit http://localhost:5173 and register/login"
echo ""
echo "📚 Full documentation: SETUP_JWT_AUTH.md"
echo ""
