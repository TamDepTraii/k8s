#Midterm - CI/CD Pipeline với GitHub Actions và ArgoCD
<img width="2441" height="1387" alt="image" src="https://github.com/user-attachments/assets/638ece9c-040c-493e-b91c-1e913fe793da" />
![Uploading image.png…]()

## Mô tả dự án
Ứng dụng Spring Boot được tự động build, test, containerize và deploy lên Kubernetes sử dụng GitHub Actions làm CI và ArgoCD làm CD (GitOps).

## 1. Chuẩn bị môi trường

### Yêu cầu
- Kubernetes cluster (Docker Desktop, Minikube, hoặc cloud K8s)
- `kubectl` đã cấu hình kết nối cluster
- `argocd` CLI (optional)
- Git

### Cài đặt ArgoCD

```bash
# Tạo namespace cho ArgoCD
kubectl create namespace argocd

# Cài đặt ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Kiểm tra ArgoCD đã chạy
kubectl get pods -n argocd
```

## 2. Truy cập ArgoCD UI

```bash
# Port forward để truy cập UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Mở: https://localhost:8080
```

Lấy password mặc định:
```bash
PS D:\Code\my-app-manifests> $ENCODED_PASSWORD = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
PS D:\Code\my-app-manifests> [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($ENCODED_PASSWORD))
```

Truy cập https://localhost:8080 để vào giao diện ArgoCD.

## 3. Thiết lập Pipeline CI (GitHub Actions)

### File: `.github/workflows/cicd-pipeline.yml`

**Quy trình:**
1. Trigger: Push code lên branch `main`
2. Build & Test: Maven compile, package, test
3. Build Docker: Multi-stage Dockerfile
4. Push Image: Đẩy lên GHCR (GitHub Container Registry)
5. Update Manifest: Cập nhật image tag trong `k8s/deployment.yaml`
6. Commit & Push: Tự động commit manifest trở lại repo

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}/k8s-app

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'
          cache: maven

      - name: Build with Maven
        run: mvn clean package -DskipTests

      - name: Run tests
        run: mvn test

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Log in to GHCR
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: ${{ github.event_name == 'push' }}
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }},${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Update deployment manifest
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        run: |
          sed -i "s|image: .*|image: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}|g" k8s/deployment.yaml
          echo "Updated deployment.yaml:"
          cat k8s/deployment.yaml

      - name: Commit and push changes
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        run: |
          git config --local user.email "github-actions[bot]@users.noreply.github.com"
          git config --local user.name "github-actions[bot]"
          git add k8s/deployment.yaml
          git commit -m "chore: update image tag to ${{ github.sha }}" || true
          git push || echo "No changes to push"
```

## 4. Tạo Application trên ArgoCD UI

**General:**
- Application Name: `k8s-demo`
- Project Name: `default`
- Sync Policy: `Automatic` (✓ Prune Resources + ✓ Self Heal)

**Source (Quan trong nhất):**
- Repository URL: `https://github.com/TamDepTraii/k8s.git`
- Revision: `HEAD`
- Path: `k8s` (nơi chứa manifests)

**Destination:**
- Cluster URL: `https://kubernetes.default.svc`
- Namespace: `k8s-demo`

Hoặc apply trực tiếp từ file:
```bash
kubectl apply -f argocd/app.yaml
```

## 5. Cấu trúc Kubernetes Manifests

### `k8s/namespace.yaml`
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: k8s-demo
  labels:
    name: k8s-demo
```

### `k8s/service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: k8s-demo
  namespace: k8s-demo
  labels:
    app: k8s-demo
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: k8s-demo
```

### `k8s/deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-demo
  namespace: k8s-demo
  labels:
    app: k8s-demo
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: k8s-demo
  template:
    metadata:
      labels:
        app: k8s-demo
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
        prometheus.io/path: "/actuator/prometheus"
    spec:
      containers:
      - name: k8s-demo
        image: ghcr.io/tamdeptraii/k8s/k8s-app:latest
        imagePullPolicy: IfNotPresent
        ports:
        - name: http
          containerPort: 8080
          protocol: TCP
        env:
        - name: SPRING_APPLICATION_NAME
          value: "k8s-demo"
        - name: MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE
          value: "health,metrics,prometheus,info"
        resources:
          requests:
            cpu: "100m"
            memory: "256Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
        livenessProbe:
          httpGet:
            path: /actuator/health/liveness
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 5
```

### `k8s/kustomization.yaml`
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: k8s-demo

labels:
  app: k8s-demo
  managed-by: argocd

commonAnnotations:
  description: "K8s Demo Application"

resources:
  - namespace.yaml
  - service.yaml
  - deployment.yaml

images:
  - name: k8s-demo
    newName: ghcr.io/tamdeptraii/k8s/k8s-app
    newTag: latest
```

## 6. Docker Build

### `Dockerfile`
```dockerfile
# Multi-stage build for Spring Boot application
# Stage 1: Build
FROM maven:3.8.6-openjdk-11 AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:resolve dependency:resolve-plugins
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:11-jre-slim
WORKDIR /app
RUN groupadd -r appuser && useradd -r -g appuser appuser
COPY --from=builder /build/target/k8s-*.jar app.jar
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8080
ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxRAMPercentage=75.0"

ENTRYPOINT ["java", "-jar", "app.jar"]
```

## 7. Workflow ArgoCD Application

**File:** `argocd/application.yaml`

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: k8s-demo
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/TamDepTraii/k8s.git
    targetRevision: main
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: k8s-demo
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

## 8. Quy trình hoạt động

```
Developer Push Code
      ↓
GitHub Actions Trigger
  ├─ Build Java (Maven)
  ├─ Run Tests
  ├─ Build Docker Image
  ├─ Push to GHCR
  ├─ Update k8s/deployment.yaml
  └─ Commit & Push to repo
      ↓
Git Repository (Manifests Updated)
      ↓
ArgoCD Watch & Sync
  ├─ Detect changes
  ├─ Validate manifests
  ├─ Apply to cluster
  └─ Create/Update resources
      ↓
Kubernetes Deployment
  ├─ Pull new image
  ├─ Rolling update
  ├─ Health checks
  └─ Service online
      ↓
Application Running ✓
```

## 9. Kiểm tra trạng thái

```bash
# Check ArgoCD application status
argocd app get k8s-demo

# Check Kubernetes resources
kubectl get all -n k8s-demo

# Check deployment
kubectl get deployment k8s-demo -n k8s-demo

# Check pods
kubectl get pods -n k8s-demo -w

# View logs
kubectl logs -f deployment/k8s-demo -n k8s-demo

# Port forward to access app
kubectl port-forward svc/k8s-demo 8080:80 -n k8s-demo

# Test application
curl http://localhost:8080/actuator/health
```

## 10. Xem chi tiết

- **SETUP.md** - Hướng dẫn thiết lập chi tiết
- **WORKFLOW.md** - Biểu đồ và luồng công việc
- **VERIFICATION.md** - Checklist xác minh

