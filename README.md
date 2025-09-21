# TJYAai - محرر الصور بالذكاء الاصطناعي

تطبيق ويب متقدم لتحرير الصور باستخدام الذكاء الاصطناعي، يوفر تحويلات فورية للصور الشخصية إلى أنماط مختلفة وميزات تحريك الصور.

## الميزات الرئيسية

- 🎨 **محرر صور AI**: تحويل الصور إلى أنماط مانجا، كرتون ثلاثي الأبعاد، أنمي، وواقعي محسن
- 💃 **تحريك الصور للرقص**: تحويل الصور الثابتة إلى فيديوهات راقصة
- 🖼️ **معرض شخصي**: تنظيم وإدارة الصور مع نظام ألبومات متقدم
- ✨ **تحسين الصور**: إصلاح السيلفي، استعادة الوجوه، تكبير الجودة
- 🎭 **مؤثرات خاصة**: فلاتر PS2 Style، مؤثرات 2000s Dreamy، مكياج افتراضي
- 👶 **AI Baby Generator**: مولد الطفل المستقبلي
- 🔄 **إزالة الخلفية**: إزالة واستبدال الخلفيات تلقائياً

## التقنيات المستخدمة

### الواجهة الأمامية
- **Next.js 14** - إطار عمل React مع SSR
- **TypeScript** - أمان الأنواع
- **Tailwind CSS** - تصميم سريع ومتسق
- **Framer Motion** - حركات وانتقالات سلسة
- **Zustand** - إدارة الحالة
- **React Query** - إدارة البيانات والكاش

### الخادم الخلفي
- **FastAPI** - إطار عمل Python عالي الأداء
- **PostgreSQL** - قاعدة بيانات علائقية
- **Redis** - كاش وصف المهام
- **Celery** - معالجة المهام في الخلفية
- **MinIO** - تخزين الكائنات (S3-compatible)

### الذكاء الاصطناعي
- **OpenAI GPT-4** - تحسين المطالب والأوصاف
- **Hugging Face Diffusers** - نماذج توليد الصور
- **Real-ESRGAN** - تكبير جودة الصور
- **GFPGAN** - تحسين الوجوه
- **MediaPipe** - كشف الملامح والوضعيات
- **First-Order-Motion-Model** - تحريك الصور

## متطلبات النظام

### للتطوير
- Python 3.11+
- Node.js 18+
- Docker & Docker Compose
- Git

### للإنتاج
- GPU: NVIDIA RTX 3060+ (12GB VRAM minimum)
- RAM: 32GB+ للـ workers
- Storage: 100GB+ SSD
- CPU: 8+ cores

## التثبيت والتشغيل

### 1. استنساخ المشروع
```bash
git clone https://github.com/drx3ai/TJYAai.git
cd TJYAai
```

### 2. إعداد متغيرات البيئة
```bash
cp .env.example .env
# قم بتحرير .env وإضافة مفاتيح API المطلوبة
```

### 3. تشغيل بـ Docker Compose
```bash
docker-compose up -d
```

### 4. الوصول للتطبيق
- الواجهة الأمامية: http://localhost:3000
- API الخلفي: http://localhost:8000
- قاعدة البيانات: localhost:5432
- Redis: localhost:6379
- MinIO: http://localhost:9001

## البنية المعمارية

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Next.js App   │────│   FastAPI       │────│   PostgreSQL    │
│   (Frontend)    │    │   (Backend)     │    │   (Database)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │
                       ┌─────────────────┐    ┌─────────────────┐
                       │   Celery        │────│   Redis         │
                       │   (Workers)     │    │   (Cache/Queue) │
                       └─────────────────┘    └─────────────────┘
                              │
                       ┌─────────────────┐
                       │   MinIO         │
                       │   (Storage)     │
                       └─────────────────┘
```

## المساهمة

1. Fork المشروع
2. إنشاء branch للميزة الجديدة (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add amazing feature'`)
4. Push للـ branch (`git push origin feature/amazing-feature`)
5. فتح Pull Request

## الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

## الدعم

للدعم والاستفسارات:
- Email: 7drabd1@gmail.com
- GitHub Issues: [إنشاء issue جديد](https://github.com/drx3ai/TJYAai/issues)

## الشكر والتقدير

- OpenAI لنماذج GPT المتقدمة
- Hugging Face لمكتبة Diffusers
- جميع مطوري المكتبات مفتوحة المصدر المستخدمة