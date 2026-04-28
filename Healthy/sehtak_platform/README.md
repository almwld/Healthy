# منصة صحتك - Sehtak Platform

منصة رعاية صحية رقمية متكاملة تربط المريضين بالأطباء والصيدليات من خلال تطبيق فلاتر وخدمة ويب متكاملة.

## هيكل المشروع

```
sehtak_platform/
├── mobile_app/          # تطبيق Flutter للموبايل
│   ├── lib/
│   │   ├── blocs/         # BLoC Pattern (Auth, Consultation, Order, Subscription)
│   │   ├── models/        # نماذج البيانات
│   │   ├── services/      # API Service + Storage Service
│   │   ├── screens/       # جميع شاشات التطبيق
│   │   ├── widgets/       # مكونات مشتركة
│   │   ├── utils/         # الثوابت والموضوعات
│   │   └── main.dart
│   ├── assets/
│   ├── test/
│   └── pubspec.yaml
├── backend/              # Backend Node.js + Express
│   ├── src/
│   │   ├── config/      # DB + Redis + Migration
│   │   ├── controllers/ # محكمات API
│   │   ├── models/      # نماذج قاعدة البيانات
│   │   ├── routes/      # مسارات API
│   │   ├── middleware/  # الميدلوير
│   │   └── server.js
│   ├── migrations/       # ملفات مقاطع القاعدة
│   ├── package.json
│   └── Dockerfile
├── ai_service/           # خدمة الذكاء الاصطناعي Python
│   ├── app.py
│   ├── triage_model.py
│   ├── requirements.txt
│   └── Dockerfile
└── deployment/           # ملفات النشر
    ├── docker-compose.yml
    ├── nginx.conf
    └── .env.example
```

## التقنولوجيا المستخدمة

### Frontend (Mobile App)
- **Flutter 3.x** + Dart
- **State Management**: flutter_bloc
- **Navigation**: go_router
- **Local Storage**: hive + shared_preferences
- **Network**: dio
- **Maps**: google_maps_flutter
- **Video Calls**: agora_rtc_engine
- **Notifications**: flutter_local_notifications + firebase_messaging

### Backend
- **Node.js** + Express
- **Database**: PostgreSQL + Redis
- **Real-time**: Socket.io
- **AI Service**: Python FastAPI
- **Containerization**: Docker + Docker Compose

## شرائح التطبيق

1. **Splash Screen** - شاشة البدء
2. **Onboarding** - 3 شرائح تعريفية
3. **Auth** - تسجيل دخول + OTP + إنشاء حساب
4. **Home** - الشاشة الرئيسية مع AI Summary
5. **Symptoms Selector** - اختيار الأعراض وجزء الجسم
6. **Active Consultation** - دردشة نصية + مكالمات
7. **Consultation History** - سجل الاستشارات
8. **Prescription** - الوصفات الطبية + PDF
9. **Pharmacies** - الصيدليات القريبة
10. **Order Tracking** - تتبع الطلب بالخريطة
11. **Profile** - الملف الشخصي
12. **Subscription** - باقات الاشتراك (49/99/189)
13. **Doctor Dashboard** - لوحة تحكم الطبيب

## طريقة التشغيل

### 1. باستخدام Docker (الطريقة الأسرع)

```bash
cd deployment
cp .env.example .env
# حدث المتغيرات في ملف .env حسب الحاجة
docker-compose up -d
```

سيتم تشغيل:
- Backend API: http://localhost:3000
- AI Service: http://localhost:8000
- PostgreSQL: localhost:5432
- Redis: localhost:6379

### 2. تشغيل Backend محلياً

```bash
cd backend
cp .env.example .env
npm install
npm run migrate  # إنشاء جداول القاعدة
npm run seed     # إضافة بيانات تجريبية
npm run dev
```

### 3. تشغيل AI Service

```bash
cd ai_service
pip install -r requirements.txt
python app.py
```

### 4. تشغيل Flutter App

```bash
cd mobile_app
flutter pub get
flutter run
```

## API Endpoints

### Auth
- `POST /api/auth/register` - إنشاء حساب
- `POST /api/auth/login` - تسجيل دخول
- `POST /api/auth/verify-otp` - تحقق OTP
- `POST /api/auth/resend-otp` - إعادة إرسال OTP
- `POST /api/auth/forgot-password` - نسيت كلمة المرور

### User
- `GET /api/user/profile` - الملف الشخصي
- `PUT /api/user/profile` - تحديث الملف
- `PUT /api/user/medical-history` - البيانات الطبية

### Consultations
- `POST /api/consultations/start` - بدء استشارة
- `GET /api/consultations` - قائمة الاستشارات
- `GET /api/consultations/:id` - تفاصيل استشارة
- `POST /api/consultations/:id/messages` - إرسال رسالة

### AI
- `POST /api/ai/triage` - فرز الحالات
- `POST /api/ai/symptom-checker` - فحص الأعراض
- `POST /api/ai/chatbot` - شات بوت

## البيانات التجريبية

المشروع يحتوي على 10 مستخدمين تجريبيين:
- 6 مريضين
- 2 أطباء
- 2 صيدليات

الباسورد: `Patient123`

## الميزات

- تحديث فوري باستخدام WebSocket
- فرز ذكي بالذكاء الاصطناعي
- دعم الوضع الليلي
- نظام اشتراكات متكامل
- تتبع الطلبات بالخريطة
- نظام إشعارات

## الترخيص

MIT License - منصة صحتك مفتوحة المصدر
