# هيكل مشروع TJYAai

```
TJYAai/
├── README.md                           # وثائق المشروع الرئيسية
├── .env.example                        # مثال على متغيرات البيئة
├── .gitignore                          # ملفات مستبعدة من Git
├── docker-compose.yml                  # إعداد Docker Compose
├── PROJECT_STRUCTURE.md               # هذا الملف
│
├── .github/                           # إعدادات GitHub
│   └── workflows/
│       └── ci-cd.yml                  # GitHub Actions CI/CD
│
├── docs/                              # الوثائق
│   ├── API.md                         # وثائق API
│   ├── DEPLOYMENT.md                  # دليل النشر
│   ├── DEVELOPMENT.md                 # دليل التطوير
│   └── PROMPTS.md                     # مجموعة المطالب الجاهزة
│
├── frontend/                          # تطبيق الواجهة الأمامية
│   ├── Dockerfile                     # Docker للواجهة الأمامية
│   ├── package.json                   # تبعيات Node.js
│   ├── next.config.js                 # إعدادات Next.js
│   ├── tailwind.config.js             # إعدادات Tailwind CSS
│   ├── tsconfig.json                  # إعدادات TypeScript
│   │
│   ├── public/                        # الملفات العامة
│   │   ├── favicon.ico
│   │   ├── logo.png
│   │   └── images/
│   │
│   └── src/                           # كود المصدر
│       ├── app/                       # Next.js App Router
│       │   ├── layout.tsx
│       │   ├── page.tsx
│       │   ├── globals.css
│       │   ├── dashboard/
│       │   ├── editor/
│       │   ├── animate/
│       │   └── gallery/
│       │
│       ├── components/                # مكونات React
│       │   ├── ui/                    # مكونات UI أساسية
│       │   ├── forms/                 # نماذج
│       │   ├── layout/                # مكونات التخطيط
│       │   ├── gallery/               # مكونات المعرض
│       │   ├── editor/                # مكونات المحرر
│       │   └── animation/             # مكونات التحريك
│       │
│       ├── hooks/                     # React Hooks مخصصة
│       │   ├── useAuth.ts
│       │   ├── useUpload.ts
│       │   ├── useImageProcessing.ts
│       │   └── useAnimation.ts
│       │
│       ├── stores/                    # إدارة الحالة (Zustand)
│       │   ├── authStore.ts
│       │   ├── galleryStore.ts
│       │   ├── editorStore.ts
│       │   └── jobsStore.ts
│       │
│       ├── types/                     # تعريفات TypeScript
│       │   ├── api.ts
│       │   ├── image.ts
│       │   ├── user.ts
│       │   └── animation.ts
│       │
│       └── utils/                     # وظائف مساعدة
│           ├── api.ts
│           ├── auth.ts
│           ├── image.ts
│           └── constants.ts
│
├── backend/                           # تطبيق الخادم الخلفي
│   ├── Dockerfile                     # Docker للخادم الخلفي
│   ├── requirements.txt               # تبعيات Python
│   ├── alembic.ini                    # إعدادات Alembic
│   │
│   ├── app/                           # كود التطبيق الرئيسي
│   │   ├── main.py                    # نقطة دخول التطبيق
│   │   ├── celery_app.py              # إعداد Celery
│   │   │
│   │   ├── api/                       # API endpoints
│   │   │   └── v1/
│   │   │       ├── router.py          # راوتر رئيسي
│   │   │       └── endpoints/
│   │   │           ├── auth.py        # المصادقة
│   │   │           ├── upload.py      # رفع الملفات
│   │   │           ├── transform.py   # تحويل الصور
│   │   │           ├── animate.py     # تحريك الصور
│   │   │           ├── gallery.py     # المعرض
│   │   │           ├── jobs.py        # المهام
│   │   │           ├── presets.py     # القوالب
│   │   │           └── users.py       # المستخدمين
│   │   │
│   │   ├── core/                      # الوظائف الأساسية
│   │   │   ├── config.py              # إعدادات التطبيق
│   │   │   ├── database.py            # اتصال قاعدة البيانات
│   │   │   ├── security.py            # الأمان والتشفير
│   │   │   ├── auth.py                # المصادقة
│   │   │   └── exceptions.py          # استثناءات مخصصة
│   │   │
│   │   ├── models/                    # نماذج قاعدة البيانات
│   │   │   ├── __init__.py
│   │   │   ├── user.py                # نموذج المستخدم
│   │   │   ├── image.py               # نموذج الصورة
│   │   │   ├── edit.py                # نموذج التحرير
│   │   │   ├── job.py                 # نموذج المهمة
│   │   │   ├── preset.py              # نموذج القالب
│   │   │   └── album.py               # نموذج الألبوم
│   │   │
│   │   ├── services/                  # خدمات الأعمال
│   │   │   ├── __init__.py
│   │   │   ├── openai_service.py      # خدمة OpenAI
│   │   │   ├── huggingface_service.py # خدمة Hugging Face
│   │   │   ├── image_service.py       # خدمة معالجة الصور
│   │   │   ├── animation_service.py   # خدمة التحريك
│   │   │   ├── storage_service.py     # خدمة التخزين
│   │   │   ├── face_detection.py      # كشف الوجوه
│   │   │   └── background_removal.py  # إزالة الخلفية
│   │   │
│   │   ├── tasks/                     # مهام Celery
│   │   │   ├── __init__.py
│   │   │   ├── image_processing.py    # معالجة الصور
│   │   │   ├── animation.py           # التحريك
│   │   │   ├── enhancement.py         # التحسين
│   │   │   └── cleanup.py             # التنظيف
│   │   │
│   │   └── utils/                     # وظائف مساعدة
│   │       ├── __init__.py
│   │       ├── image_utils.py         # أدوات الصور
│   │       ├── file_utils.py          # أدوات الملفات
│   │       ├── validation.py          # التحقق من البيانات
│   │       └── helpers.py             # وظائف مساعدة عامة
│   │
│   ├── migrations/                    # ملفات Alembic
│   │   └── versions/
│   │
│   ├── sql/                           # ملفات SQL
│   │   └── init.sql                   # إعداد قاعدة البيانات الأولي
│   │
│   └── tests/                         # اختبارات الوحدة
│       ├── __init__.py
│       ├── conftest.py                # إعدادات pytest
│       ├── test_auth.py               # اختبارات المصادقة
│       ├── test_upload.py             # اختبارات الرفع
│       ├── test_transform.py          # اختبارات التحويل
│       ├── test_animate.py            # اختبارات التحريك
│       └── test_services.py           # اختبارات الخدمات
│
├── docker/                            # ملفات Docker إضافية
│   ├── nginx/
│   │   ├── nginx.conf                 # إعدادات Nginx
│   │   └── ssl/                       # شهادات SSL
│   │
│   └── scripts/
│       ├── init-db.sh                 # إعداد قاعدة البيانات
│       └── backup.sh                  # نسخ احتياطي
│
├── models/                            # نماذج AI (غير مدرجة في Git)
│   ├── stable-diffusion/
│   ├── real-esrgan/
│   ├── gfpgan/
│   ├── fomm/
│   └── rembg/
│
├── templates/                         # قوالب التحريك
│   ├── dance/
│   │   ├── dance_01_keyframes.json
│   │   ├── dance_02_keyframes.json
│   │   └── dance_03_keyframes.json
│   │
│   └── motion/
│       ├── head_turn.json
│       ├── smile.json
│       └── blink.json
│
└── scripts/                           # سكريبتات مساعدة
    ├── setup.sh                       # إعداد البيئة
    ├── download_models.py             # تحميل النماذج
    ├── migrate.py                     # تشغيل migrations
    └── deploy.sh                      # نشر التطبيق
```

## وصف المجلدات الرئيسية

### Frontend (الواجهة الأمامية)
- **Next.js 14** مع App Router
- **TypeScript** للأمان في الكتابة
- **Tailwind CSS** للتصميم
- **Zustand** لإدارة الحالة
- **React Query** لإدارة البيانات

### Backend (الخادم الخلفي)
- **FastAPI** كإطار عمل رئيسي
- **SQLAlchemy** للتعامل مع قاعدة البيانات
- **Celery** لمعالجة المهام في الخلفية
- **Redis** للكاش وصف المهام
- **PostgreSQL** كقاعدة بيانات رئيسية

### Services (الخدمات)
- **OpenAI Service**: تحسين المطالب والأوصاف
- **Hugging Face Service**: نماذج توليد الصور
- **Animation Service**: تحريك الصور
- **Image Service**: معالجة وتحسين الصور
- **Storage Service**: إدارة تخزين الملفات

### Models (النماذج)
- نماذج Stable Diffusion للتوليد
- Real-ESRGAN لتكبير الجودة
- GFPGAN لتحسين الوجوه
- First-Order-Motion-Model للتحريك
- rembg لإزالة الخلفية

### Docker
- **docker-compose.yml**: تشغيل جميع الخدمات
- **Dockerfile** منفصل لكل خدمة
- **Nginx** كـ reverse proxy
- **PostgreSQL** و **Redis** كخدمات

### CI/CD
- **GitHub Actions** للتكامل المستمر
- اختبارات تلقائية للكود
- بناء ونشر Docker images
- فحص الأمان التلقائي