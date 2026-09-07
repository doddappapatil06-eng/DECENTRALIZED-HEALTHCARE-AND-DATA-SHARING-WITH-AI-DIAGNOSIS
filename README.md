# 🏥 CareAI – Decentralized Healthcare Data Sharing with AI Diagnosis

## 📌 Overview

CareAI is a secure healthcare management platform that enables hospitals and doctors to manage patient records efficiently while maintaining privacy and security. The system integrates Artificial Intelligence (AI), OCR, OTP-based access control, and decentralized healthcare concepts.

The platform allows hospitals to create patient records, upload medical reports, and manage healthcare data securely. Doctors can access patient information only after patient verification and receive AI-assisted diagnosis generated from uploaded reports.

---

## 🚀 Features

### 🔐 Secure Authentication

- JWT-based Authentication
- Hospital Registration & Login
- Doctor Registration & Login
- Role-Based Access Control

### 👨‍⚕️ Hospital Dashboard

#### Patient Management

- Create Patient
- Generate Unique Patient ID
- Verify Patient Mobile Number using OTP
- View Patient List
- Search Patients
- View Patient Details
- Print Patient Information
- Download Patient Information PDF

#### Medical Records

Upload reports under:

- Basic Details
- Test Reports
- Scanning Reports
- Treatment Details

Supported Formats:

- PDF
- JPG
- JPEG
- PNG

### 🩺 Doctor Dashboard

#### Patient Access

Search patients using:

- Patient ID
- Patient Name
- Phone Number

#### Secure Verification

- OTP Verification
- Temporary Access Control

#### Patient Information

View:

- Patient Details
- Uploaded Reports
- AI Diagnosis Report

---

## 🤖 AI Diagnosis System

The AI module automatically analyzes uploaded reports.

### OCR Processing

Extracts medical information from:

- PDFs
- Images
- Scanned Documents

### Medical Value Detection

Identifies:

- Blood Glucose
- HbA1c
- Blood Pressure
- BMI
- Cholesterol
- Heart Rate
- Insulin Values

### Disease Prediction

Predicts:

- Diabetes Risk
- Heart Disease Risk
- Hypertension Risk
- General Health Status

### Doctor Guidance

Provides:

- Clinical Observations
- Medical Findings
- Follow-Up Recommendations
- Specialist Referral Suggestions

---

## 🔒 Security Features

- JWT Authentication
- OTP Verification
- Role-Based Access Control
- Protected APIs
- Secure Medical Record Access
- Patient Consent-Based Viewing

---

## 🏗 System Architecture

Frontend (React.js)

⬇

Backend APIs (Django REST Framework)

⬇

SQLite Database

⬇

OCR Engine (Tesseract OCR)

⬇

AI Diagnosis Module

⬇

Patient Records & Reports

---

## 🛠 Technology Stack

### Frontend

- React.js
- Axios
- React Router
- React Toastify
- HTML5
- CSS3

### Backend

- Django
- Django REST Framework
- Simple JWT

### Database

- SQLite

### AI & OCR

- Python
- Tesseract OCR
- PDFPlumber
- Pillow

### Security

- JWT Authentication
- OTP Verification

### Future Technologies

- IPFS
- Ethereum Blockchain
- Solidity
- Ganache

---

## 📂 Project Structure

```bash
CareAI/
│
├── backend/
│   ├── authapp/
│   ├── patients/
│   ├── records/
│   ├── otp/
│   ├── ai/
│   ├── blockchain/
│   └── careai/
│
├── frontend/
│   ├── src/
│   ├── components/
│   ├── pages/
│   └── styles/
│
├── docs/
│
└── README.md
```

## ⚙️ Installation

### Backend Setup

```bash
cd backend

# Linux / macOS
python -m venv .venv

# Windows PowerShell (if python is not on PATH)
& "C:\Users\dodda\AppData\Local\Programs\Python\Python311\python.exe" -m venv .venv

# Activate virtual environment
# PowerShell
.\.venv\Scripts\Activate.ps1
# Or Command Prompt
# .venv\Scripts\activate.bat

pip install -r requirements.txt

python manage.py migrate

python manage.py runserver
```

### Frontend Setup

```bash
cd frontend

npm install

npm run dev
```

Frontend:

```text
http://localhost:5173
```

Backend:

```text
http://127.0.0.1:8000
```

---

## 📋 Workflow

### Hospital Workflow

1. Register/Login
2. Create Patient
3. Verify Patient OTP
4. Generate Patient ID
5. Upload Reports
6. AI Analysis Generated
7. View Patient Records

### Doctor Workflow

1. Register/Login
2. Search Patient
3. Verify Patient OTP
4. Access Records
5. Review AI Diagnosis
6. Provide Treatment Recommendations

---

## 📊 AI Diagnosis Output

```text
AI Diagnosis Report

Possible Condition:
High Diabetes Risk

Medical Findings:
Glucose: 190 mg/dL
HbA1c: 8.1%
Blood Pressure: 150/95

Doctor Guidance:
• Review glucose trends
• Assess diabetic complications
• Refer to endocrinologist

Recommended Follow-Up:
• Repeat HbA1c after 3 months
• Monitor blood glucose weekly
• Nutritional counselling
```

---

## 🎯 Project Objectives

- Secure healthcare data management
- AI-assisted disease diagnosis
- OTP-based patient verification
- Organized medical record storage
- Improved healthcare accessibility
- Enhanced patient privacy

---

## 🔮 Future Enhancements

- Blockchain-based record storage
- IPFS Integration
- Deep Learning Diagnosis Models
- Mobile Application
- Cloud Deployment
- Multi-Hospital Integration
- Real-Time Telemedicine Support

---

## 👨‍💻 Developed By

**team **

B.Tech – Artificial Intelligence & Data Science

**Project Title:** CareAI – Decentralized Healthcare Data Sharing with AI Diagnosis

---

## 📜 License

This project is developed for academic and educational purposes.
