# دليل التطوير - TJYAai

## البدء السريع

### المتطلبات الأساسية
- Docker & Docker Compose
- Git
- Node.js 18+ (للتطوير المحلي)
- Python 3.11+ (للتطوير المحلي)

### الإعداد الأولي

1. **استنساخ المشروع**
```bash
git clone https://github.com/drx3ai/TJYAai.git
cd TJYAai
```

2. **تشغيل سكريبت الإعداد**
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

3. **تحرير متغيرات البيئة**
```bash
cp .env.example .env
# قم بتحرير .env وإضافة مفاتيح API الخاصة بك
```

4. **تشغيل التطبيق**
```bash
docker-compose up
```

## بنية التطوير

### الواجهة الأمامية (Frontend)

```bash
cd frontend
npm install
npm run dev
```

**الأوامر المتاحة:**
- `npm run dev` - تشغيل خادم التطوير
- `npm run build` - بناء للإنتاج
- `npm run start` - تشغيل الإنتاج
- `npm run lint` - فحص الكود
- `npm run type-check` - فحص TypeScript

### الخادم الخلفي (Backend)

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Linux/Mac
# أو
venv\Scripts\activate     # Windows
pip install -r requirements.txt
uvicorn app.main:app --reload
```

**الأوامر المتاحة:**
- `uvicorn app.main:app --reload` - تشغيل خادم التطوير
- `pytest` - تشغيل الاختبارات
- `alembic upgrade head` - تشغيل migrations
- `celery -A app.celery_app worker --loglevel=info` - تشغيل Celery worker

## إدارة قاعدة البيانات

### إنشاء Migration جديد
```bash
cd backend
alembic revision --autogenerate -m "وصف التغيير"
```

### تطبيق Migrations
```bash
alembic upgrade head
```

### العودة لـ Migration سابق
```bash
alembic downgrade -1
```

## اختبار التطبيق

### اختبارات الخادم الخلفي
```bash
cd backend
pytest tests/ -v
```

### اختبارات الواجهة الأمامية
```bash
cd frontend
npm run test
```

### اختبارات التكامل
```bash
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
```

## تطوير الميزات

### إضافة نمط تحويل جديد

1. **إضافة القالب في قاعدة البيانات**
```sql
INSERT INTO presets (name, type, prompt_template, default_params) 
VALUES ('نمط جديد', 'style', 'وصف النمط...', '{"strength": 0.8}');
```

2. **إضافة المعالج في الخادم الخلفي**
```python
# في app/services/image_service.py
async def apply_new_style(image_path: str, params: dict):
    # منطق التحويل
    pass
```

3. **إضافة واجهة المستخدم**
```tsx
// في frontend/src/components/editor/StyleSelector.tsx
const NewStyleButton = () => {
  // واجهة اختيار النمط
};
```

### إضافة قالب رقص جديد

1. **إنشاء ملف keyframes**
```json
// في templates/dance/new_dance.json
{
  "name": "رقص جديد",
  "duration": 3.0,
  "keyframes": [
    {"time": 0.0, "pose": [...]},
    {"time": 1.0, "pose": [...]}
  ]
}
```

2. **تسجيل القالب**
```python
# في app/services/animation_service.py
DANCE_TEMPLATES["new_dance"] = load_template("new_dance.json")
```

## نشر التطبيق

### البناء للإنتاج
```bash
docker-compose -f docker-compose.prod.yml build
```

### النشر باستخدام Docker
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### النشر على Kubernetes
```bash
kubectl apply -f k8s/
```

## مراقبة الأداء

### مراقبة الخدمات
```bash
docker-compose logs -f [service_name]
```

### مراقبة استخدام الموارد
```bash
docker stats
```

### مراقبة المهام
```bash
# Celery Flower
celery -A app.celery_app flower
# ثم زيارة http://localhost:5555
```

## استكشاف الأخطاء

### مشاكل شائعة

**1. خطأ في الاتصال بقاعدة البيانات**
```bash
# تحقق من حالة PostgreSQL
docker-compose ps postgres
# إعادة تشغيل الخدمة
docker-compose restart postgres
```

**2. مشاكل في تحميل النماذج**
```bash
# تحقق من مساحة القرص
df -h
# تنظيف الملفات المؤقتة
docker system prune -f
```

**3. بطء في معالجة الصور**
```bash
# تحقق من استخدام GPU
nvidia-smi  # إذا كان متاحاً
# زيادة عدد workers
docker-compose scale celery-worker=4
```

### سجلات التطبيق

**عرض سجلات الخدمة**
```bash
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f celery-worker
```

**عرض سجلات قاعدة البيانات**
```bash
docker-compose logs -f postgres
```

## المساهمة في المشروع

### قواعد الكود

1. **Python (Backend)**
   - استخدم Black للتنسيق
   - اتبع PEP 8
   - اكتب docstrings للوظائف
   - أضف type hints

2. **TypeScript (Frontend)**
   - استخدم Prettier للتنسيق
   - اتبع ESLint rules
   - استخدم TypeScript بدقة
   - اكتب JSDoc للمكونات المعقدة

### عملية المراجعة

1. إنشاء branch جديد
2. تطوير الميزة
3. كتابة الاختبارات
4. إنشاء Pull Request
5. مراجعة الكود
6. دمج التغييرات

### اختبار الجودة

```bash
# فحص الكود
cd backend && black . && flake8
cd frontend && npm run lint && npm run type-check

# تشغيل الاختبارات
cd backend && pytest
cd frontend && npm test

# فحص الأمان
docker run --rm -v $(pwd):/app securecodewarrior/docker-security-scan
```

## الموارد المفيدة

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Docker Compose](https://docs.docker.com/compose/)
- [PostgreSQL](https://www.postgresql.org/docs/)
- [Redis](https://redis.io/documentation)
- [Celery](https://docs.celeryproject.org/)

## الدعم

للحصول على المساعدة:
1. تحقق من الوثائق أولاً
2. ابحث في Issues الموجودة
3. أنشئ Issue جديد مع تفاصيل المشكلة
4. تواصل مع الفريق عبر البريد الإلكتروني