# دليل النشر - TJYAai

## نظرة عامة على النشر

يدعم TJYAai عدة طرق للنشر حسب احتياجاتك:

- **التطوير المحلي**: Docker Compose
- **النشر السحابي**: Kubernetes + Helm
- **النشر المبسط**: Docker Swarm
- **النشر على الخدمات السحابية**: AWS, GCP, Azure

## المتطلبات الأساسية

### الحد الأدنى للموارد
- **CPU**: 4 cores (8 cores مُوصى به)
- **RAM**: 8GB (16GB مُوصى به)
- **Storage**: 50GB SSD (100GB مُوصى به)
- **GPU**: اختياري لتسريع معالجة الصور (NVIDIA RTX 3060 أو أعلى)

### البرمجيات المطلوبة
- Docker 20.10+
- Docker Compose 2.0+
- Kubernetes 1.24+ (للنشر على Kubernetes)
- Helm 3.8+ (للنشر على Kubernetes)

## النشر المحلي باستخدام Docker Compose

### 1. الإعداد الأولي

```bash
# استنساخ المشروع
git clone https://github.com/AZDriveai/TJYAai.git
cd TJYAai

# إعداد متغيرات البيئة
cp .env.example .env
# قم بتحرير .env وإضافة مفاتيح API الخاصة بك

# تشغيل سكريبت الإعداد
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 2. تشغيل التطبيق

```bash
# تشغيل جميع الخدمات
docker-compose up -d

# مراقبة السجلات
docker-compose logs -f

# التحقق من حالة الخدمات
docker-compose ps
```

### 3. الوصول للتطبيق

- **الواجهة الأمامية**: http://localhost:3000
- **API الخلفي**: http://localhost:8000
- **مراقبة Celery**: http://localhost:5555
- **قاعدة البيانات**: localhost:5432

## النشر على Kubernetes

### 1. إعداد Kubernetes

```bash
# إنشاء namespace
kubectl create namespace tjyaai

# إنشاء secrets
kubectl create secret generic tjyaai-secrets \
  --from-literal=openai-api-key="your_openai_key" \
  --from-literal=hf-token="your_hf_token" \
  --from-literal=jwt-secret="your_jwt_secret" \
  --namespace=tjyaai
```

### 2. نشر قاعدة البيانات

```yaml
# k8s/postgres.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: tjyaai
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15
        env:
        - name: POSTGRES_DB
          value: tjyaai
        - name: POSTGRES_USER
          value: postgres
        - name: POSTGRES_PASSWORD
          value: password
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: postgres-storage
        persistentVolumeClaim:
          claimName: postgres-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: postgres-service
  namespace: tjyaai
spec:
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
```

### 3. نشر Redis

```yaml
# k8s/redis.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: tjyaai
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:7-alpine
        ports:
        - containerPort: 6379
---
apiVersion: v1
kind: Service
metadata:
  name: redis-service
  namespace: tjyaai
spec:
  selector:
    app: redis
  ports:
  - port: 6379
    targetPort: 6379
```

### 4. نشر الخادم الخلفي

```yaml
# k8s/backend.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: tjyaai
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: tjyaai/backend:latest
        env:
        - name: DATABASE_URL
          value: "postgresql://postgres:password@postgres-service:5432/tjyaai"
        - name: REDIS_URL
          value: "redis://redis-service:6379"
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: tjyaai-secrets
              key: openai-api-key
        ports:
        - containerPort: 8000
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
  namespace: tjyaai
spec:
  selector:
    app: backend
  ports:
  - port: 8000
    targetPort: 8000
```

### 5. نشر Celery Workers

```yaml
# k8s/celery-worker.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: celery-worker
  namespace: tjyaai
spec:
  replicas: 2
  selector:
    matchLabels:
      app: celery-worker
  template:
    metadata:
      labels:
        app: celery-worker
    spec:
      containers:
      - name: celery-worker
        image: tjyaai/backend:latest
        command: ["celery", "-A", "app.celery_app", "worker", "--loglevel=info"]
        env:
        - name: DATABASE_URL
          value: "postgresql://postgres:password@postgres-service:5432/tjyaai"
        - name: REDIS_URL
          value: "redis://redis-service:6379"
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: tjyaai-secrets
              key: openai-api-key
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
```

### 6. نشر الواجهة الأمامية

```yaml
# k8s/frontend.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: tjyaai
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: tjyaai/frontend:latest
        env:
        - name: NEXT_PUBLIC_API_URL
          value: "http://backend-service:8000"
        ports:
        - containerPort: 3000
        resources:
          requests:
            memory: "256Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "200m"
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: tjyaai
spec:
  selector:
    app: frontend
  ports:
  - port: 3000
    targetPort: 3000
```

### 7. إعداد Ingress

```yaml
# k8s/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tjyaai-ingress
  namespace: tjyaai
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - tjyaai.com
    - api.tjyaai.com
    secretName: tjyaai-tls
  rules:
  - host: tjyaai.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 3000
  - host: api.tjyaai.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 8000
```

### 8. تطبيق التكوين

```bash
# تطبيق جميع ملفات Kubernetes
kubectl apply -f k8s/

# مراقبة حالة النشر
kubectl get pods -n tjyaai
kubectl get services -n tjyaai
kubectl get ingress -n tjyaai
```

## النشر على AWS

### 1. إعداد EKS

```bash
# إنشاء EKS cluster
eksctl create cluster \
  --name tjyaai-cluster \
  --region us-west-2 \
  --nodegroup-name tjyaai-nodes \
  --node-type m5.large \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 5 \
  --managed
```

### 2. إعداد RDS

```bash
# إنشاء RDS PostgreSQL instance
aws rds create-db-instance \
  --db-instance-identifier tjyaai-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --master-username postgres \
  --master-user-password your-password \
  --allocated-storage 20 \
  --vpc-security-group-ids sg-xxxxxxxx
```

### 3. إعداد ElastiCache

```bash
# إنشاء Redis cluster
aws elasticache create-cache-cluster \
  --cache-cluster-id tjyaai-redis \
  --cache-node-type cache.t3.micro \
  --engine redis \
  --num-cache-nodes 1
```

### 4. إعداد S3

```bash
# إنشاء S3 bucket للصور
aws s3 mb s3://tjyaai-images
aws s3 mb s3://tjyaai-models

# إعداد CORS
aws s3api put-bucket-cors \
  --bucket tjyaai-images \
  --cors-configuration file://s3-cors.json
```

## النشر على Google Cloud Platform

### 1. إعداد GKE

```bash
# إنشاء GKE cluster
gcloud container clusters create tjyaai-cluster \
  --zone us-central1-a \
  --num-nodes 3 \
  --machine-type n1-standard-2 \
  --enable-autoscaling \
  --min-nodes 1 \
  --max-nodes 5
```

### 2. إعداد Cloud SQL

```bash
# إنشاء PostgreSQL instance
gcloud sql instances create tjyaai-db \
  --database-version POSTGRES_14 \
  --tier db-f1-micro \
  --region us-central1
```

### 3. إعداد Cloud Storage

```bash
# إنشاء bucket للصور
gsutil mb gs://tjyaai-images
gsutil mb gs://tjyaai-models
```

## مراقبة ومتابعة الأداء

### 1. إعداد Prometheus

```yaml
# monitoring/prometheus.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: tjyaai
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus:latest
        ports:
        - containerPort: 9090
        volumeMounts:
        - name: prometheus-config
          mountPath: /etc/prometheus
      volumes:
      - name: prometheus-config
        configMap:
          name: prometheus-config
```

### 2. إعداد Grafana

```yaml
# monitoring/grafana.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: tjyaai
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:latest
        ports:
        - containerPort: 3000
        env:
        - name: GF_SECURITY_ADMIN_PASSWORD
          value: admin
```

### 3. مراقبة السجلات

```bash
# مراقبة سجلات الخدمات
kubectl logs -f deployment/backend -n tjyaai
kubectl logs -f deployment/celery-worker -n tjyaai
kubectl logs -f deployment/frontend -n tjyaai

# مراقبة استخدام الموارد
kubectl top pods -n tjyaai
kubectl top nodes
```

## النسخ الاحتياطي والاستعادة

### 1. نسخ احتياطي لقاعدة البيانات

```bash
# إنشاء نسخة احتياطية
kubectl exec -it postgres-pod -n tjyaai -- pg_dump -U postgres tjyaai > backup.sql

# استعادة النسخة الاحتياطية
kubectl exec -i postgres-pod -n tjyaai -- psql -U postgres tjyaai < backup.sql
```

### 2. نسخ احتياطي للصور

```bash
# نسخ احتياطي لـ S3/MinIO
aws s3 sync s3://tjyaai-images ./backup/images/
aws s3 sync s3://tjyaai-models ./backup/models/
```

## استكشاف الأخطاء

### مشاكل شائعة

**1. فشل في تحميل النماذج**
```bash
# تحقق من مساحة القرص
kubectl exec -it celery-worker-pod -n tjyaai -- df -h

# تحقق من الذاكرة
kubectl top pods -n tjyaai
```

**2. بطء في معالجة الصور**
```bash
# زيادة عدد workers
kubectl scale deployment celery-worker --replicas=4 -n tjyaai

# تحقق من استخدام GPU
kubectl exec -it celery-worker-pod -n tjyaai -- nvidia-smi
```

**3. مشاكل في الاتصال**
```bash
# تحقق من حالة الخدمات
kubectl get services -n tjyaai
kubectl describe service backend-service -n tjyaai

# تحقق من DNS
kubectl exec -it frontend-pod -n tjyaai -- nslookup backend-service
```

## الأمان في الإنتاج

### 1. تشفير البيانات

```yaml
# إعداد TLS
apiVersion: v1
kind: Secret
metadata:
  name: tjyaai-tls
  namespace: tjyaai
type: kubernetes.io/tls
data:
  tls.crt: <base64-encoded-cert>
  tls.key: <base64-encoded-key>
```

### 2. إدارة الأسرار

```bash
# استخدام Sealed Secrets
kubectl create secret generic tjyaai-secrets \
  --from-literal=openai-api-key="$OPENAI_API_KEY" \
  --dry-run=client -o yaml | \
  kubeseal -o yaml > sealed-secret.yaml
```

### 3. شبكة الأمان

```yaml
# Network Policies
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: tjyaai-network-policy
  namespace: tjyaai
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: tjyaai
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: tjyaai
```

## التحديث والصيانة

### 1. تحديث التطبيق

```bash
# بناء صورة جديدة
docker build -t tjyaai/backend:v2.0 ./backend
docker build -t tjyaai/frontend:v2.0 ./frontend

# دفع الصور
docker push tjyaai/backend:v2.0
docker push tjyaai/frontend:v2.0

# تحديث النشر
kubectl set image deployment/backend backend=tjyaai/backend:v2.0 -n tjyaai
kubectl set image deployment/frontend frontend=tjyaai/frontend:v2.0 -n tjyaai
```

### 2. تحديث قاعدة البيانات

```bash
# تشغيل migrations
kubectl exec -it backend-pod -n tjyaai -- alembic upgrade head
```

### 3. صيانة دورية

```bash
# تنظيف الصور القديمة
kubectl exec -it backend-pod -n tjyaai -- python scripts/cleanup_old_images.py

# تحسين قاعدة البيانات
kubectl exec -it postgres-pod -n tjyaai -- psql -U postgres -c "VACUUM ANALYZE;"
```

هذا الدليل يوفر إرشادات شاملة لنشر TJYAai في بيئات مختلفة. اختر الطريقة التي تناسب احتياجاتك ومتطلبات مشروعك.