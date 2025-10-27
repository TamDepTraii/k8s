```bash
# Logs của deployment
kubectl logs deployment/k8s-deployment

# Logs real-time
kubectl logs -f deployment/k8s-deployment

# Logs của pod cụ thể
kubectl logs <pod-name>

# Logs của container cụ thể
kubectl logs <pod-name> -c <container-name>
```

### Kiểm Tra Health

```bash
# Health check
curl http://localhost:8080/actuator/health

# Metrics
curl http://localhost:8080/actuator/metrics

# Prometheus metrics
curl http://localhost:8080/actuator/prometheus
```

---

## 🔧 Troubleshooting

### ❌ Docker Image Build Thất Bại

**Lỗi: "Java version not supported"**

```bash
# Kiểm tra Java version
java -version

# Phải là Java 11+
# Update Java nếu cần

# Sửa pom.xml
```

**Giải pháp**: Cập nhật source Java version trong pom.xml:

```xml
<maven.compiler.source>11</maven.compiler.source>
<maven.compiler.target>11</maven.compiler.target>
```

### ❌ ArgoCD Không Kết Nối

**Lỗi: "Connection refused"**

```bash
# Kiểm tra pods
kubectl -n argocd get pods

# Kiểm tra services
kubectl -n argocd get svc

# Xem logs
kubectl -n argocd logs deployment/argocd-server
```

### ❌ Image Not Found in Kubernetes

**Lỗi: "ImagePullBackOff"**

```yaml
# Kiểm tra deployment.yaml
imagePullPolicy: Never  # Dùng local image

# Hoặc tag đúng image
docker tag k8s-demo:latest <registry>/k8s-demo:latest
docker push <registry>/k8s-demo:latest
```

### ❌ Port-Forward Không Hoạt Động

```bash
# Kiểm tra port đang được dùng
netstat -ano | findstr :8080

# Dùng port khác
kubectl port-forward svc/argocd-server 9090:443

# Hoặc kill process trên port
taskkill /PID <PID> /F
```

---

## 🎓 Các Bước Tiếp Theo

### 1. Kết Nối Git Repository với ArgoCD

```bash
# Thêm repository
argocd repo add https://github.com/TamDepTraii/k8s.git \
  --username <username> \
  --password <token>
```

### 2. Cấu Hình Auto-Sync

Chỉnh sửa `argocd/application.yaml`:

```yaml
syncPolicy:
  automated:
    prune: true      # Xóa resources bị xóa từ Git
    selfHeal: true   # Tự fix nếu thay đổi manual
```

### 3. Thiết Lập Monitoring

```bash
# Cài Prometheus
kubectl apply -f k8s/prometheus-config.yaml

# Cài Grafana
# kubectl apply -f grafana/

# Port-forward
kubectl port-forward svc/prometheus 9090:9090
```

### 4. Enable HTTPS cho ArgoCD

```bash
# Tạo self-signed certificate
# kubectl create secret tls argocd-server-tls ...

# Hoặc sử dụng cert-manager
```

---

## 📚 Tài Liệu Tham Khảo

- **Spring on Kubernetes**: https://spring.io/guides/topicals/spring-on-kubernetes
- **Kubernetes Docs**: https://kubernetes.io/docs/
- **ArgoCD Docs**: https://argo-cd.readthedocs.io/
- **Docker Docs**: https://docs.docker.com/

---

## 🤝 Hỗ Trợ

Nếu gặp vấn đề:

1. Kiểm tra file `ARGOCD_LOGIN_SOLUTION.md`
2. Xem logs: `kubectl logs ...`
3. Kiểm tra status: `kubectl get pods`, `kubectl describe pod ...`
4. Xem troubleshooting guide

---

## 📝 Ghi Chú

- Lần đầu build image có thể mất 5-10 phút
- Đảm bảo Docker Desktop running trước khi deploy
- Kubernetes must be enabled trong Docker Desktop
- Port-forward cần giữ cửa sổ PowerShell mở

---

**Happy Deploying! 🚀**

Last Updated: 2025-10-27
# 🚀 Spring Boot on Kubernetes + ArgoCD

Dự án demo CI/CD với Spring Boot, Kubernetes, và ArgoCD.

**GitHub Repository**: https://github.com/TamDepTraii/k8s.git

---

## 📋 Mục Lục

1. [Giới Thiệu](#giới-thiệu)
2. [Yêu Cầu](#yêu-cầu)
3. [Cài Đặt Nhanh](#cài-đặt-nhanh)
4. [Hướng Dẫn Chi Tiết](#hướng-dẫn-chi-tiết)
5. [Đăng Nhập ArgoCD](#đăng-nhập-argocd)
6. [Xem Docker Images](#xem-docker-images)
7. [Troubleshooting](#troubleshooting)

---

## 🎯 Giới Thiệu

Đây là một ứng dụng Spring Boot mẫu được triển khai trên Kubernetes với ArgoCD để quản lý deployment tự động.

**Stack công nghệ:**
- ☕ Spring Boot 2.7.16
- 🐳 Docker & Container Images
- ⚙️ Kubernetes Orchestration
- 🔄 ArgoCD GitOps
- 📊 Prometheus Monitoring
- 🎯 HPA (Horizontal Pod Autoscaler)

---

## ✅ Yêu Cầu

- **OS**: Windows / Mac / Linux
- **Docker Desktop**: Cài đặt với Kubernetes enabled
- **kubectl**: v1.24+
- **Git**: Để clone repository
- **Java**: 11+
- **Maven**: 3.6+ (hoặc dùng mvnw)

### Kiểm Tra Yêu Cầu

```powershell
# Kiểm tra Docker
docker version

# Kiểm tra Kubernetes
kubectl version --client

# Kiểm tra Java
java -version

# Kiểm tra Maven
mvn --version
```

---

## 🚀 Cài Đặt Nhanh

### Bước 1: Clone Repository

```bash
git clone https://github.com/TamDepTraii/k8s.git
cd k8s
```

### Bước 2: Build Docker Image

```bash
# Sử dụng Spring Boot Cloud Native Buildpacks
./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest

# Hoặc trên Windows
.\mvnw.cmd spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

### Bước 3: Kiểm Tra Docker Image

```bash
docker images | grep k8s-demo
```

**Kết quả mong đợi:**
```
REPOSITORY          TAG       IMAGE ID      CREATED      SIZE
k8s-demo            latest    abc123def456  X hours ago  325MB
```

### Bước 4: Deploy lên Kubernetes

```bash
# Áp dụng namespace
kubectl apply -f k8s/namespace.yaml

# Áp dụng deployment
kubectl apply -f k8s/deployment.yaml

# Áp dụng service
kubectl apply -f k8s/service.yaml

# Kiểm tra
kubectl get all -n default
```

### Bước 5: Setup ArgoCD

```bash
# Cài đặt ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Đợi pods sẵn sàng
kubectl -n argocd wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --timeout=60s

# Port-forward
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

### Bước 6: Truy Cập ArgoCD

Mở trình duyệt: https://localhost:8080

**Thông tin đăng nhập:**
- Username: `admin`
- Password: Xem [Đăng Nhập ArgoCD](#đăng-nhập-argocd)

---

## 📖 Hướng Dẫn Chi Tiết

### 1️⃣ Cấu Trúc Thư Mục

```
k8s/
├── src/
│   ├── main/
│   │   ├── java/com/example/k8s/       # Source code
│   │   └── resources/
│   │       └── application.properties   # Config
│   └── test/
├── k8s/
│   ├── namespace.yaml                   # Kubernetes namespace
│   ├── deployment.yaml                  # Pod deployment
│   ├── service.yaml                     # Service
│   ├── configmap.yaml                   # ConfigMap
│   ├── hpa.yaml                         # Auto-scaling
│   └── kustomization.yaml               # Kustomize config
├── argocd/
│   ├── application.yaml                 # ArgoCD Application
│   └── argocd-config.yaml               # ArgoCD Configuration
├── docker-compose.yml                   # Docker Compose
├── Dockerfile                           # Docker image definition
└── pom.xml                              # Maven configuration
```

### 2️⃣ Build Docker Image

#### Phương Pháp 1: Spring Boot Build Pack (Khuyên Dùng)

```bash
./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

**Ưu điểm:**
- Không cần Dockerfile
- Optimized image size
- Best practices tích hợp

#### Phương Pháp 2: Dockerfile Truyền Thống

```bash
# Build
docker build -t k8s-demo:latest .

# Tag cho registry
docker tag k8s-demo:latest yourusername/k8s-demo:latest

# Push
docker push yourusername/k8s-demo:latest
```

### 3️⃣ Deploy lên Kubernetes

```bash
# Tạo namespace
kubectl create namespace k8s-demo

# Deploy all resources
kubectl apply -f k8s/ -n k8s-demo

# Kiểm tra pods
kubectl get pods -n k8s-demo

# Xem logs
kubectl logs -f <pod-name> -n k8s-demo

# Port-forward để test
kubectl port-forward svc/k8s-service 8080:8080 -n k8s-demo
```

### 4️⃣ Cấu Hình ArgoCD Application

Tạo file `argocd/application.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: k8s-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/TamDepTraii/k8s.git
    targetRevision: main
    path: k8s/
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

Áp dụng:

```bash
kubectl apply -f argocd/application.yaml
```

---

## 🔐 Đăng Nhập ArgoCD

### 📌 Thông Tin Đăng Nhập

```
Username: admin
Password: Tmpr4695958
```

### 🔧 Bước 1: Mở Port-Forward

```powershell
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

Kết quả:
```
Forwarding from 127.0.0.1:8080 -> 8443
```

**⚠️ Giữ cửa sổ PowerShell này mở!**

### 🌐 Bước 2: Truy Cập Web

Mở trình duyệt:
```
https://localhost:8080
```

**Xử lý cảnh báo SSL:**
- Click "Advanced" → "Proceed to localhost (unsafe)"

### ✍️ Bước 3: Đăng Nhập

```
Username: admin
Password: Tmpr4695958
```

Click **"SIGN IN"**

### 📸 Giao Diện ArgoCD

Sau khi đăng nhập thành công, bạn sẽ thấy:

1. **Applications** - Danh sách ứng dụng
2. **Repositories** - Repository được kết nối
3. **Clusters** - Kubernetes clusters
4. **Settings** - Cấu hình

---

## 🐳 Xem Docker Images

### Cách 1: Docker CLI

```bash
# Liệt kê tất cả images
docker images

# Tìm image của bạn
docker images | grep k8s

# Xem chi tiết image
docker inspect k8s-demo:latest

# Xem lịch sử layers
docker history k8s-demo:latest
```

### Cách 2: Từ Kubernetes

```bash
# Xem pods đang chạy
kubectl get pods -o wide

# Xem chi tiết pod (bao gồm image)
kubectl describe pod <pod-name>

# Xem tất cả containers
kubectl get pods -o jsonpath='{..image}'

# Export toàn bộ thông tin
kubectl get pods -o yaml
```

### Cách 3: Từ ArgoCD UI

1. Đăng nhập ArgoCD
2. Click **"Applications"**
3. Chọn ứng dụng của bạn
4. Xem tab **"Network" → "Pods"**
5. Click vào pod để xem image details

---

## 📊 Monitoring & Logs

### Kiểm Tra Logs


