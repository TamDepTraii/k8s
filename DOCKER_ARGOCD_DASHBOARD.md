# 🎯 Docker Image & ArgoCD Dashboard

## ✅ Docker Image Status

### 📦 Ứng dụng của bạn
```
Repository: k8s-demo
Tag:        latest
Image ID:   33f9685a1674
Size:       496MB
Status:     ✅ READY
```

### 📋 Chi tiết Build
- **Buildpack:** paketobuildpacks/builder:base
- **Base Image:** paketobuildpacks/run:base-cnb
- **Platform:** Spring Boot 2.7.16
- **Java:** 11
- **Application Name:** k8s-demo
- **Port:** 9090

---

## 🎮 ArgoCD Dashboard

### 🔐 Truy cập
- **URL:** https://localhost:8443
- **Username:** admin
- **Password:** Chạy lệnh sau để lấy:
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
  ```

### 📊 Tính năng
1. **Applications** - Quản lý ứng dụng Kubernetes
2. **Repositories** - Kết nối Git repositories
3. **Projects** - Tổ chức projects
4. **Settings** - Cấu hình hệ thống

---

## 🚀 Các bước để deploy với ArgoCD

### Step 1: Đăng nhập ArgoCD
```
https://localhost:8443
admin / <password>
```

### Step 2: Thêm Repository
1. Vào **Settings** → **Repositories**
2. Click **CONNECT REPO**
3. URL: `https://github.com/TamDepTraii/k8s.git`
4. Chọn **HTTPS** method
5. Click **CONNECT**

### Step 3: Tạo Application
1. Click **+ NEW APP**
2. **Application Name:** k8s-demo
3. **Project:** default
4. **Repository URL:** https://github.com/TamDepTraii/k8s.git
5. **Path:** k8s
6. **Cluster:** https://kubernetes.default.svc
7. **Namespace:** k8s-demo
8. Click **CREATE**

### Step 4: Xem Docker Image
1. Chọn Application `k8s-demo`
2. Xem "Application Resources" section
3. Tìm Deployment pod → xem container image: `k8s-demo:latest`

---

## 🐳 Xem Docker Images từ Command Line

```bash
# Liệt kê tất cả images
docker images

# Xem chi tiết image
docker inspect k8s-demo:latest

# Xem image layers
docker history k8s-demo:latest

# Push image lên Docker Hub (nếu cần)
docker tag k8s-demo:latest <your-docker-hub>/k8s-demo:latest
docker push <your-docker-hub>/k8s-demo:latest
```

---

## 📌 Kubernetes Deployment

### Xem deployment
```bash
kubectl get deployments -n k8s-demo
kubectl describe deployment <deployment-name> -n k8s-demo
```

### Xem pods
```bash
kubectl get pods -n k8s-demo
kubectl describe pod <pod-name> -n k8s-demo
```

### Port-forward ứng dụng
```bash
kubectl port-forward svc/k8s-demo-service -n k8s-demo 9090:80
```

---

## ✨ Thông tin hữu ích

| Thành phần | Địa chỉ | Trạng thái |
|-----------|--------|----------|
| Spring Boot App | http://localhost:9090 | ✅ Running |
| ArgoCD Dashboard | https://localhost:8443 | ✅ Running |
| Docker Image | k8s-demo:latest | ✅ Built |
| Git Repository | https://github.com/TamDepTraii/k8s.git | 📝 |

---

**Bạn có thể bắt đầu truy cập các dịch vụ! 🚀**

