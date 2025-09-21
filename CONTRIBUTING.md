# دليل المساهمة في TJYAai 🤝

نرحب بمساهماتكم في تطوير TJYAai! هذا الدليل سيساعدكم على فهم كيفية المساهمة بفعالية في المشروع.

## 📋 جدول المحتويات

- [كيفية المساهمة](#كيفية-المساهمة)
- [إعداد بيئة التطوير](#إعداد-بيئة-التطوير)
- [معايير الكود](#معايير-الكود)
- [عملية المراجعة](#عملية-المراجعة)
- [الإبلاغ عن الأخطاء](#الإبلاغ-عن-الأخطاء)
- [اقتراح الميزات](#اقتراح-الميزات)

## 🚀 كيفية المساهمة

### 1. Fork المشروع
```bash
# انقر على زر Fork في GitHub أو استخدم GitHub CLI
gh repo fork AZDriveai/TJYAai
```

### 2. استنساخ المشروع محلياً
```bash
git clone https://github.com/YOUR_USERNAME/TJYAai.git
cd TJYAai
```

### 3. إعداد Remote للمشروع الأصلي
```bash
git remote add upstream https://github.com/AZDriveai/TJYAai.git
```

### 4. إنشاء Branch جديد
```bash
git checkout -b feature/your-feature-name
# أو
git checkout -b fix/bug-description
```

### 5. تطبيق التغييرات
- اكتب الكود الخاص بك
- اتبع معايير الكود المحددة
- أضف اختبارات للميزات الجديدة
- حدث الوثائق إذا لزم الأمر

### 6. Commit التغييرات
```bash
git add .
git commit -m "feat: add new image transformation feature"
```

### 7. Push إلى GitHub
```bash
git push origin feature/your-feature-name
```

### 8. إنشاء Pull Request
- اذهب إلى صفحة المشروع على GitHub
- انقر على "New Pull Request"
- اختر branch الخاص بك
- اكتب وصفاً واضحاً للتغييرات

## 🛠️ إعداد بيئة التطوير

### المتطلبات الأساسية
- Python 3.11+
- Node.js 18+
- Docker & Docker Compose
- Git

### إعداد البيئة

```bash
# 1. استنساخ المشروع
git clone https://github.com/YOUR_USERNAME/TJYAai.git
cd TJYAai

# 2. إعداد متغيرات البيئة
cp .env.example .env
# قم بتحرير .env وإضافة مفاتيح API للتطوير

# 3. تشغيل سكريبت الإعداد
chmod +x scripts/setup.sh
./scripts/setup.sh

# 4. تشغيل التطبيق في وضع التطوير
docker-compose up -d
```

### إعداد التطوير المحلي (بدون Docker)

#### الخادم الخلفي
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Linux/Mac
# أو
venv\Scripts\activate  # Windows

pip install -r requirements.txt
pip install -r requirements-dev.txt

# تشغيل قاعدة البيانات والخدمات
docker-compose up -d postgres redis minio

# تشغيل الخادم
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

#### الواجهة الأمامية
```bash
cd frontend
npm install
npm run dev
```

#### Celery Workers
```bash
cd backend
celery -A app.celery_app worker --loglevel=info
```

## 📝 معايير الكود

### Python (Backend)

#### تنسيق الكود
```bash
# استخدم Black لتنسيق الكود
black app/ tests/

# استخدم isort لترتيب الاستيرادات
isort app/ tests/

# استخدم flake8 للتحقق من جودة الكود
flake8 app/ tests/
```

#### معايير التسمية
- استخدم `snake_case` للمتغيرات والوظائف
- استخدم `PascalCase` للفئات
- استخدم `UPPER_CASE` للثوابت
- أسماء وصفية وواضحة

#### مثال على كود Python جيد:
```python
from typing import Optional, List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserResponse
from app.services.user_service import UserService

router = APIRouter(prefix="/users", tags=["users"])

@router.post("/", response_model=UserResponse)
async def create_user(
    user_data: UserCreate,
    db: Session = Depends(get_db)
) -> UserResponse:
    """
    إنشاء مستخدم جديد.
    
    Args:
        user_data: بيانات المستخدم الجديد
        db: جلسة قاعدة البيانات
        
    Returns:
        UserResponse: بيانات المستخدم المُنشأ
        
    Raises:
        HTTPException: إذا كان البريد الإلكتروني مستخدماً مسبقاً
    """
    user_service = UserService(db)
    
    if await user_service.get_by_email(user_data.email):
        raise HTTPException(
            status_code=400,
            detail="البريد الإلكتروني مستخدم مسبقاً"
        )
    
    user = await user_service.create(user_data)
    return UserResponse.from_orm(user)
```

### TypeScript/React (Frontend)

#### تنسيق الكود
```bash
# استخدم Prettier لتنسيق الكود
npm run format

# استخدم ESLint للتحقق من جودة الكود
npm run lint
```

#### معايير التسمية
- استخدم `camelCase` للمتغيرات والوظائف
- استخدم `PascalCase` للمكونات والأنواع
- استخدم `UPPER_CASE` للثوابت
- أسماء وصفية وواضحة

#### مثال على كود React جيد:
```typescript
import React, { useState, useCallback } from 'react';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'react-hot-toast';

import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { uploadImage } from '@/services/api';
import { ImageUploadResponse } from '@/types/api';

interface ImageUploadProps {
  onUploadSuccess: (response: ImageUploadResponse) => void;
  maxFileSize?: number;
  acceptedTypes?: string[];
}

export const ImageUpload: React.FC<ImageUploadProps> = ({
  onUploadSuccess,
  maxFileSize = 10 * 1024 * 1024, // 10MB
  acceptedTypes = ['image/jpeg', 'image/png', 'image/webp']
}) => {
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const queryClient = useQueryClient();

  const uploadMutation = useMutation({
    mutationFn: uploadImage,
    onSuccess: (response) => {
      toast.success('تم رفع الصورة بنجاح');
      onUploadSuccess(response);
      setSelectedFile(null);
      queryClient.invalidateQueries({ queryKey: ['images'] });
    },
    onError: (error) => {
      toast.error('فشل في رفع الصورة');
      console.error('Upload error:', error);
    }
  });

  const handleFileSelect = useCallback((event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    
    if (!file) return;
    
    if (!acceptedTypes.includes(file.type)) {
      toast.error('نوع الملف غير مدعوم');
      return;
    }
    
    if (file.size > maxFileSize) {
      toast.error('حجم الملف كبير جداً');
      return;
    }
    
    setSelectedFile(file);
  }, [acceptedTypes, maxFileSize]);

  const handleUpload = useCallback(() => {
    if (!selectedFile) return;
    
    const formData = new FormData();
    formData.append('file', selectedFile);
    
    uploadMutation.mutate(formData);
  }, [selectedFile, uploadMutation]);

  return (
    <div className="space-y-4">
      <Input
        type="file"
        accept={acceptedTypes.join(',')}
        onChange={handleFileSelect}
        disabled={uploadMutation.isPending}
      />
      
      {selectedFile && (
        <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
          <span className="text-sm text-gray-600">
            {selectedFile.name} ({(selectedFile.size / 1024 / 1024).toFixed(2)} MB)
          </span>
          
          <Button
            onClick={handleUpload}
            loading={uploadMutation.isPending}
            disabled={!selectedFile}
          >
            رفع الصورة
          </Button>
        </div>
      )}
    </div>
  );
};
```

## 🧪 الاختبارات

### اختبارات الخادم الخلفي
```bash
cd backend

# تشغيل جميع الاختبارات
pytest

# تشغيل اختبارات محددة
pytest tests/test_user_service.py

# تشغيل مع تقرير التغطية
pytest --cov=app tests/
```

### اختبارات الواجهة الأمامية
```bash
cd frontend

# تشغيل اختبارات الوحدة
npm run test

# تشغيل اختبارات E2E
npm run test:e2e

# تشغيل مع مراقبة التغييرات
npm run test:watch
```

### كتابة اختبارات جديدة

#### مثال اختبار Python:
```python
import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from app.main import app
from app.core.database import get_db
from app.models.user import User
from tests.utils import create_test_user

client = TestClient(app)

def test_create_user_success(db: Session):
    """اختبار إنشاء مستخدم جديد بنجاح."""
    user_data = {
        "email": "test@example.com",
        "password": "testpassword123",
        "full_name": "Test User"
    }
    
    response = client.post("/api/users/", json=user_data)
    
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == user_data["email"]
    assert data["full_name"] == user_data["full_name"]
    assert "id" in data
    assert "password" not in data  # التأكد من عدم إرجاع كلمة المرور

def test_create_user_duplicate_email(db: Session):
    """اختبار منع إنشاء مستخدم ببريد إلكتروني مكرر."""
    # إنشاء مستخدم أولاً
    existing_user = create_test_user(db, email="test@example.com")
    
    user_data = {
        "email": "test@example.com",  # نفس البريد الإلكتروني
        "password": "testpassword123",
        "full_name": "Another User"
    }
    
    response = client.post("/api/users/", json=user_data)
    
    assert response.status_code == 400
    assert "البريد الإلكتروني مستخدم مسبقاً" in response.json()["detail"]
```

#### مثال اختبار React:
```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { toast } from 'react-hot-toast';

import { ImageUpload } from '@/components/ImageUpload';
import { uploadImage } from '@/services/api';

// Mock الخدمات الخارجية
jest.mock('@/services/api');
jest.mock('react-hot-toast');

const mockUploadImage = uploadImage as jest.MockedFunction<typeof uploadImage>;
const mockToast = toast as jest.Mocked<typeof toast>;

describe('ImageUpload', () => {
  let queryClient: QueryClient;

  beforeEach(() => {
    queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
        mutations: { retry: false }
      }
    });
    jest.clearAllMocks();
  });

  const renderComponent = (props = {}) => {
    const defaultProps = {
      onUploadSuccess: jest.fn(),
      ...props
    };

    return render(
      <QueryClientProvider client={queryClient}>
        <ImageUpload {...defaultProps} />
      </QueryClientProvider>
    );
  };

  test('يجب أن يعرض حقل رفع الملف', () => {
    renderComponent();
    
    const fileInput = screen.getByRole('textbox', { hidden: true });
    expect(fileInput).toBeInTheDocument();
    expect(fileInput).toHaveAttribute('type', 'file');
  });

  test('يجب أن يرفع الصورة بنجاح', async () => {
    const mockResponse = { id: '1', url: 'https://example.com/image.jpg' };
    mockUploadImage.mockResolvedValue(mockResponse);
    
    const onUploadSuccess = jest.fn();
    renderComponent({ onUploadSuccess });

    // إنشاء ملف وهمي
    const file = new File(['test'], 'test.jpg', { type: 'image/jpeg' });
    
    const fileInput = screen.getByRole('textbox', { hidden: true });
    fireEvent.change(fileInput, { target: { files: [file] } });

    // انتظار ظهور زر الرفع
    const uploadButton = await screen.findByText('رفع الصورة');
    fireEvent.click(uploadButton);

    await waitFor(() => {
      expect(mockUploadImage).toHaveBeenCalledWith(expect.any(FormData));
      expect(onUploadSuccess).toHaveBeenCalledWith(mockResponse);
      expect(mockToast.success).toHaveBeenCalledWith('تم رفع الصورة بنجاح');
    });
  });

  test('يجب أن يرفض الملفات غير المدعومة', () => {
    renderComponent();

    const file = new File(['test'], 'test.txt', { type: 'text/plain' });
    const fileInput = screen.getByRole('textbox', { hidden: true });
    
    fireEvent.change(fileInput, { target: { files: [file] } });

    expect(mockToast.error).toHaveBeenCalledWith('نوع الملف غير مدعوم');
  });
});
```

## 🔍 عملية المراجعة

### قبل إرسال Pull Request

1. **تأكد من نجاح جميع الاختبارات**
   ```bash
   # الخادم الخلفي
   cd backend && pytest
   
   # الواجهة الأمامية
   cd frontend && npm run test
   ```

2. **تحقق من جودة الكود**
   ```bash
   # Python
   cd backend
   black app/ tests/
   isort app/ tests/
   flake8 app/ tests/
   
   # TypeScript
   cd frontend
   npm run lint
   npm run format
   ```

3. **حدث الوثائق**
   - أضف تعليقات للوظائف الجديدة
   - حدث README.md إذا لزم الأمر
   - أضف أمثلة للاستخدام

4. **اكتب رسالة commit واضحة**
   ```bash
   # استخدم التنسيق التالي:
   type(scope): description
   
   # أمثلة:
   feat(auth): add OAuth2 authentication
   fix(upload): resolve file size validation issue
   docs(api): update endpoint documentation
   test(user): add user service unit tests
   ```

### أنواع Commits

- `feat`: ميزة جديدة
- `fix`: إصلاح خطأ
- `docs`: تحديث الوثائق
- `style`: تغييرات التنسيق (لا تؤثر على الكود)
- `refactor`: إعادة هيكلة الكود
- `test`: إضافة أو تحديث الاختبارات
- `chore`: مهام الصيانة

### مراجعة الكود

عند مراجعة Pull Requests، نركز على:

- **الوظائف**: هل الكود يعمل كما هو متوقع؟
- **الأداء**: هل هناك تحسينات ممكنة؟
- **الأمان**: هل هناك ثغرات أمنية؟
- **القابلية للقراءة**: هل الكود واضح ومفهوم؟
- **الاختبارات**: هل الاختبارات شاملة وكافية؟
- **الوثائق**: هل الوثائق محدثة ودقيقة؟

## 🐛 الإبلاغ عن الأخطاء

### قبل الإبلاغ عن خطأ

1. تأكد من أن الخطأ لم يتم الإبلاغ عنه مسبقاً
2. تحقق من أنك تستخدم أحدث إصدار
3. جرب إعادة إنتاج الخطأ في بيئة نظيفة

### معلومات مطلوبة

عند الإبلاغ عن خطأ، يرجى تضمين:

- **وصف واضح للخطأ**
- **خطوات إعادة الإنتاج**
- **السلوك المتوقع**
- **السلوك الفعلي**
- **لقطات شاشة (إذا أمكن)**
- **معلومات البيئة**:
  - نظام التشغيل
  - إصدار المتصفح
  - إصدار Python/Node.js
  - إصدار Docker

### قالب الإبلاغ عن خطأ

```markdown
## وصف الخطأ
وصف واضح ومختصر للخطأ.

## خطوات إعادة الإنتاج
1. اذهب إلى '...'
2. انقر على '...'
3. مرر إلى '...'
4. شاهد الخطأ

## السلوك المتوقع
وصف واضح لما كنت تتوقع حدوثه.

## السلوك الفعلي
وصف واضح لما حدث فعلاً.

## لقطات الشاشة
إذا أمكن، أضف لقطات شاشة لتوضيح المشكلة.

## معلومات البيئة
- نظام التشغيل: [مثل iOS, Windows, Linux]
- المتصفح: [مثل Chrome, Safari, Firefox]
- الإصدار: [مثل 22]

## معلومات إضافية
أي معلومات أخرى حول المشكلة.
```

## 💡 اقتراح الميزات

### قبل اقتراح ميزة جديدة

1. تحقق من أن الميزة لم يتم اقتراحها مسبقاً
2. فكر في كيفية تناسب الميزة مع أهداف المشروع
3. اعتبر التأثير على الأداء والأمان

### معلومات مطلوبة

عند اقتراح ميزة، يرجى تضمين:

- **وصف واضح للميزة**
- **المشكلة التي تحلها**
- **الحلول البديلة المعتبرة**
- **أمثلة على الاستخدام**
- **التأثير على المستخدمين**

### قالب اقتراح الميزة

```markdown
## ملخص الميزة
وصف مختصر للميزة المقترحة.

## المشكلة
وصف واضح للمشكلة التي تحلها هذه الميزة.

## الحل المقترح
وصف واضح لما تريد حدوثه.

## الحلول البديلة
وصف أي حلول بديلة أو ميزات اعتبرتها.

## أمثلة الاستخدام
أمثلة محددة على كيفية استخدام هذه الميزة.

## التأثير
كيف ستؤثر هذه الميزة على المستخدمين والمطورين؟

## معلومات إضافية
أي معلومات أخرى حول الميزة المقترحة.
```

## 🏷️ التسميات (Labels)

نستخدم التسميات التالية لتنظيم Issues و Pull Requests:

### نوع المشكلة
- `bug`: خطأ في الكود
- `enhancement`: تحسين على ميزة موجودة
- `feature`: ميزة جديدة
- `documentation`: تحديث الوثائق
- `question`: سؤال أو استفسار

### الأولوية
- `priority: high`: أولوية عالية
- `priority: medium`: أولوية متوسطة
- `priority: low`: أولوية منخفضة

### الحالة
- `status: needs review`: يحتاج مراجعة
- `status: in progress`: قيد التطوير
- `status: blocked`: محجوب
- `status: ready`: جاهز للدمج

### المجال
- `area: frontend`: الواجهة الأمامية
- `area: backend`: الخادم الخلفي
- `area: ai`: الذكاء الاصطناعي
- `area: database`: قاعدة البيانات
- `area: deployment`: النشر

## 🎯 نصائح للمساهمين الجدد

### ابدأ صغيراً
- ابحث عن Issues مع تسمية `good first issue`
- ابدأ بإصلاح الأخطاء الصغيرة أو تحسين الوثائق
- اطرح الأسئلة إذا لم تكن متأكداً

### تواصل مع المجتمع
- انضم إلى المناقشات في Issues
- اطلب المساعدة عند الحاجة
- شارك أفكارك واقتراحاتك

### تعلم من الكود الموجود
- اقرأ الكود الموجود لفهم الأنماط
- اتبع نفس أسلوب التسمية والتنظيم
- استخدم نفس المكتبات والأدوات

## 📞 التواصل

إذا كان لديك أسئلة حول المساهمة:

- 💬 **المناقشات**: [GitHub Discussions](https://github.com/AZDriveai/TJYAai/discussions)
- 🐛 **الأخطاء**: [GitHub Issues](https://github.com/AZDriveai/TJYAai/issues)
- 📧 **البريد الإلكتروني**: contribute@tjyaai.com

---

شكراً لك على اهتمامك بالمساهمة في TJYAai! مساهماتك تساعد في جعل التطبيق أفضل للجميع. 🙏