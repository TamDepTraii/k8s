# 🚀 BẮTĐẦU ĐÂY - Spring Boot on Kubernetes + ArgoCD

**Xin chào! Hãy bắt đầu từ tài liệu này.**

---

## 📊 Tình Trạng Hiện Tại

✅ **Hoàn Thành:**
- Spring Boot application
- Docker image setup
- Kubernetes manifests
- ArgoCD installation
- Monitoring configuration

🔄 **Tiếp Theo:**
1. [Đăng Nhập ArgoCD](#-đăng-nhập-argocd-và-xem-images)
2. [Push Lên GitHub](#-push-lên-github)
3. [Configure Auto-Deployment](#-configure-auto-deployment)

---

## ✅ Bước 1: Kiểm Tra Yêu Cầu

Trước tiên, đảm bảo bạn có:

- ✓ Docker Desktop (với Kubernetes enabled)
- ✓ kubectl
- ✓ Git
- ✓ Java 11+

```powershell
# Kiểm tra Docker
docker version

# Kiểm tra Kubernetes
kubectl cluster-info

# Kiểm tra ArgoCD pods
kubectl -n argocd get pods
```

**Kết quả mong đợi:** Tất cả pods trong argocd namespace đang `Running` ✓

---

## 🔐 Bước 2: Đăng Nhập ArgoCD và Xem Images

### 2.1 Mở Port-Forward

Mở **PowerShell** mới và chạy:

```powershell
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

**Kết quả:**
```
Forwarding from 127.0.0.1:8080 -> 8443
```

**⚠️ Giữ cửa sổ này mở!**

### 2.2 Truy Cập ArgoCD

Mở trình duyệt và vào:
```
https://localhost:8080
```

**Bạn sẽ thấy cảnh báo SSL:**
- Click "Advanced"
- Click "Proceed to localhost (unsafe)"

### 2.3 Đăng Nhập

Nhập thông tin:
- **Username**: `admin`
- **Password**: `Tmpr4695958`

Click **"SIGN IN"**

### ✅ Đăng Nhập Thành Công!

Bây giờ bạn sẽ thấy ArgoCD dashboard.

### 2.4 Xem Docker Images

**Cách 1: Từ Docker CLI** (PowerShell mới)

```powershell
docker images | grep k8s
```

**Kết quả:**
```
k8s-demo        latest    abc123    2 hours ago    325MB
```

**Cách 2: Từ Kubernetes**

```powershell
kubectl get pods
kubectl describe pod <pod-name>
```

**Cách 3: Từ ArgoCD UI**

1. Click **"Applications"** (menu trái)
2. Chọn application nếu có
3. Xem tab **"Summary"** → **"Containers"**

---

## 📤 Bước 3: Push Lên GitHub

### 3.1 Kiểm Tra Files

```powershell
cd D:\ki1nam3\PTUDDN\k8s
git status
```

**Bạn sẽ thấy:**
- Files được sửa
- Files mới (README_SETUP.md, ARGOCD_LOGIN_SOLUTION.md, v.v.)

### 3.2 Thêm Tất Cả Files

```powershell
git add -A
```

### 3.3 Commit

```powershell
git commit -m "Add: Complete Kubernetes and ArgoCD setup"
```

### 3.4 Push lên GitHub

```powershell
git push origin main
```

**Nếu lỗi authentication:**
- Dùng GitHub Personal Access Token (PAT)
- Hoặc setup SSH key

👉 **Xem chi tiết**: `GITHUB_PUSH_GUIDE.md`

### ✅ Push Thành Công!

Kiểm tra trên GitHub:
```
https://github.com/TamDepTraii/k8s
```

---

## 🎯 Bước 4: Configure Auto-Deployment

### 4.1 Kết Nối Git Repository

Trong ArgoCD UI:

1. Click **"Settings"** (menu trái)
2. Click **"Repositories"**
3. Click **"CONNECT REPO"**

**Nhập thông tin:**
- **Connection method**: HTTPS
- **Repository URL**: `https://github.com/TamDepTraii/k8s.git`
- **Username**: GitHub username
- **Password**: Personal Access Token (PAT)

Click **"CONNECT"**

### 4.2 Tạo Application

1. Click **"Applications"** 
2. Click **"NEW APP"**

**Nhập thông tin:**
- **Application Name**: `k8s-app`
- **Project**: `default`
- **Repo URL**: `https://github.com/TamDepTraii/k8s.git`
- **Path**: `k8s/` (hoặc nơi chứa manifests)
- **Destination Server**: `https://kubernetes.default.svc`
- **Destination Namespace**: `default`

**Sync Policy:**
- ✓ Enable **"Automated"**
- ✓ Enable **"Prune Resources"**
- ✓ Enable **"Self Heal"**

Click **"CREATE"**

### ✅ Application Created!

Bây giờ ArgoCD sẽ tự động deploy khi bạn push lên Git!

---

## 📚 Tài Liệu Hữu Ích

| Tài Liệu | Nội Dung |
|---------|---------|
| **README_SETUP.md** | Hướng dẫn setup chi tiết |
| **ARGOCD_LOGIN_SOLUTION.md** | Hướng dẫn đăng nhập ArgoCD |
| **GITHUB_PUSH_GUIDE.md** | Hướng dẫn push lên GitHub |
| **ARGOCD_LOGIN_GUIDE.md** | Troubleshooting đăng nhập |

---

## 🆘 Gặp Vấn Đề?

### ❌ ArgoCD không truy cập được?
- ✅ Kiểm tra port-forward có chạy không
- ✅ Xem: `ARGOCD_LOGIN_SOLUTION.md`

### ❌ Docker image không build?
- ✅ Kiểm tra Java version
- ✅ Xem: `README_SETUP.md` → Troubleshooting

### ❌ Không push lên GitHub?
- ✅ Kiểm tra credentials
- ✅ Xem: `GITHUB_PUSH_GUIDE.md` → Troubleshooting

### ❌ Kubernetes pods không chạy?
```powershell
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

---

## 🎓 Các Bước Tiếp Theo

1. **Setup CI/CD** - GitHub Actions
2. **Auto-Deploy** - Khi push lên main branch
3. **Monitoring** - Prometheus + Grafana
4. **Scaling** - Horizontal Pod Autoscaler
5. **SSL/TLS** - Let's Encrypt

---

## 💾 Cheat Sheet

```powershell
# === KUBERNETES ===
kubectl get pods                           # Xem pods
kubectl logs -f <pod>                      # Logs real-time
kubectl port-forward svc/<svc> 8080:8080   # Port forward
kubectl describe pod <pod>                 # Chi tiết pod

# === ARGOCD ===
kubectl -n argocd port-forward svc/argocd-server 8080:443   # Port forward
kubectl -n argocd get pods                 # Xem pods
kubectl -n argocd logs deployment/argocd-server             # Logs

# === DOCKER ===
docker images                               # Xem images
docker ps                                   # Xem containers
docker logs <container>                     # Logs
docker build -t <name> .                   # Build image

# === GIT ===
git status                                  # Xem status
git add -A                                  # Add files
git commit -m "message"                     # Commit
git push origin main                        # Push
```

---

## 📞 Thông Tin Liên Lạc

- **Repository**: https://github.com/TamDepTraii/k8s.git
- **ArgoCD URL**: https://localhost:8080
- **Username**: admin
- **Password**: Tmpr4695958

---

## ✨ Tóm Tắt

| Bước | Tác Vụ | Trạng Thái |
|-----|--------|-----------|
| 1 | Kiểm Tra Yêu Cầu | ✅ |
| 2 | Đăng Nhập ArgoCD | 🔄 **(BẠN Ở ĐÂY)** |
| 3 | Push Lên GitHub | ⬜ |
| 4 | Configure Auto-Deploy | ⬜ |
| 5 | Setup CI/CD | ⬜ |

---

**Bước tiếp theo: Đăng nhập ArgoCD (Bước 2) ↑**

**Good luck! 🚀**

Last Updated: 2025-10-27

