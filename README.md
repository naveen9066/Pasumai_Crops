# Pasumai_Crops
# 🌾 PASUMAI CROPS – Smart Agriculture App

**PASUMAI CROPS** is a comprehensive agriculture assistance platform built for farmers and agricultural officers. It integrates AI-driven crop diagnosis, digital farmer management, supplements marketplace, agri calendar, and real-time market information – all in a multi-language supported mobile app.

---

## 🚀 Features

### 👨‍🌾 Farmer Modules
- **Farmer Registration**
  - Name, Mobile, Aadhar, District, Taluk, Village
  - Upload documents (Land Record, Ration Card, Profile Image)

- **Crop Diagnosis (AI-powered)**
  - Upload crop image
  - Get instant disease detection & solution suggestions

- **Supplements Store**
  - Seed, Fertilizer, and Vegetable supplements
  - Payment & order management

- **Market Information**
  - Live prices based on district
  - Crop-based price trends

- **Agri News**
  - Daily agricultural updates and schemes

- **Agri Calendar**
  - Month-wise activities and tips
  - Season-specific planning

- **Feedback Module**
  - Collect feedback and suggestions from users

---

## 🔐 Admin Dashboard

- Login portal for Admin
- View, Approve, or Reject farmer registrations
- Monitor orders and supplements
- Upload news & calendar data
- AI model management

---

## 🌐 Multi-language Support

Supports the following languages:
- Tamil
- English
- Hindi
- Malayalam

---

## 🛠️ Tech Stack

| Frontend      | Backend        | AI/ML Integration | Database / Storage |
|---------------|----------------|-------------------|--------------------|
| Flutter       | Node.js + Express | Custom Trained Model | Supabase / Firebase |
| Dart          | REST API       | TensorFlow / PyTorch | Cloud Storage (Docs, Images) |

---

## 📁 Project Structure
PASUMAI-CROPS/
│
├── frontend/ # Flutter source code
│ ├── lib/
│ ├── assets/
│ └── pubspec.yaml
│
├── backend/ # Node.js + Express backend
│ ├── controllers/
│ ├── routes/
│ ├── services/
│ ├── uploads/
│ └── app.js
│
├── ai_model/ # AI crop diagnosis model
│ └── model.pt
│
├── docs/ # Screenshots and PDFs
│
└── README.md
---
## 🧪 How to Run

### 🖥️ Backend Setup

```bash
cd backend
npm install
npm start

### 🖥️ Frontend Setup

cd frontend
flutter pub get
flutter run
----
⚙️ AI Model
Hosted separately or integrated using REST API (gemini api)
Accepts crop image input
Returns prediction with suggestions
---
📦 Deployment

Backend: Deployed on Render
Frontend: Flutter APK via Android Studio 
Database: Supabase for Auth & Data Storage
---
✨ Future Enhancements

Weather-based alerts
Voice input and TTS
Offline mode
Integration with government schemes
---
📄 License
This project is licensed under the MIT License.
----
## 🧑‍💻 Developed By

- **Name**: Naveen S  
- **Role**: Flutter Developer 
- **Email**: naveenjkkm9066@gmail.com.com  
- **GitHub**: https://github.com/naveen9066/Pasumai_Crops.git
- **LinkedIn**: https://www.linkedin.com/in/naveensakthivel 
---
🙌 Acknowledgements

Inspired by Harvest Hub concept
Support from TCS mentoring
Powered by OpenAI (AI module assistance)
---
“விவசாயம் வளர்த்தால் நாடு வளரும்”
– Pasumai Crops Team







