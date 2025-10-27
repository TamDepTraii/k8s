```
=== ArgoCD ===
URL: https://localhost:8080
Username: admin
Password: Tmpr4695958

=== GitHub ===
Repo: https://github.com/TamDepTraii/k8s.git
Branch: main

=== Docker ===
Image: k8s-demo:latest
```

---

**Bạn Đã Hoàn Thành Setup! 🚀**

**Last Updated: 2025-10-27**
# 🎬 HÀNH ĐỘNG CUỐI CÙNG - Hãy Làm Ngay!

## ⏰ Thời Gian Ước Tính: 20 phút

---

## ✅ Bước 1: Đăng Nhập ArgoCD (5 phút)

### 1.1 Mở Terminal PowerShell (New)

```powershell
# Không dùng terminal cũ - mở terminal mới
# Nhấn: Win + PowerShell
# Hoặc: right-click → Open PowerShell here
```

### 1.2 Chạy Port-Forward

```powershell
cd D:\ki1nam3\PTUDDN\k8s
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

**Kết quả:**
```
Forwarding from 127.0.0.1:8080 -> 8443
```

**⚠️ QUAN TRỌNG: Giữ terminal này MỞ!**

### 1.3 Mở Trình Duyệt

Mở tab browser mới:
```
https://localhost:8080
```

### 1.4 Xử Lý Cảnh Báo SSL

- Trình duyệt sẽ cảnh báo "Your connection is not private"
- **Chrome**: Click "Advanced" → "Proceed to localhost (unsafe)"
- **Firefox**: Click "Advanced" → "Accept Risk and Continue"
- **Edge**: Click "Advanced" → "Continue to localhost"

### 1.5 Đăng Nhập

```
Username: admin
Password: Tmpr4695958
```

Nhấn **"SIGN IN"**

### ✅ Bạn đã đăng nhập ArgoCD!

---

## ✅ Bước 2: Xem Docker Images (5 phút)

**Mở Terminal Mới (không dùng terminal port-forward):**

### 2.1 Xem Tất Cả Images

```powershell
docker images
```

**Tìm dòng:**
```
k8s-demo     latest     <ID>     <time>     325MB
```

### 2.2 Xem Chi Tiết Images

```powershell
docker inspect k8s-demo:latest
```

### 2.3 Xem Trong Kubernetes

```powershell
kubectl get pods
kubectl describe pod <pod-name>
```

### ✅ Bạn đã xem Docker images!

---

## ✅ Bước 3: Push Lên GitHub (5 phút)

**Mở Terminal Mới:**

### 3.1 Vào Thư Mục Project

```powershell
cd D:\ki1nam3\PTUDDN\k8s
```

### 3.2 Kiểm Tra Git Status

```powershell
git status
```

**Bạn sẽ thấy:**
```
Untracked files:
  00_START_HERE.md
  README_SETUP.md
  ARGOCD_LOGIN_SOLUTION.md
  ...
```

### 3.3 Thêm Tất Cả Files

```powershell
git add -A
```

### 3.4 Commit

```powershell
git commit -m "Add: Complete Kubernetes and ArgoCD setup with documentation"
```

### 3.5 Push Lên GitHub

```powershell
git push origin main
```

**Nếu lỗi authentication:**
```powershell
# Dùng Personal Access Token (PAT)
# Tạo trên: https://github.com/settings/tokens
git push https://<YOUR_TOKEN>@github.com/TamDepTraii/k8s.git main

# Hoặc dùng SSH
git push git@github.com:TamDepTraii/k8s.git main
```

### ✅ Push Thành Công!

**Kiểm tra:**
- Vào https://github.com/TamDepTraii/k8s
- Thấy files mới: `00_START_HERE.md`, `README_SETUP.md`, etc.
- Xem commit history

---

## ✅ Bước 4: Configure ArgoCD Application (5 phút)

**Trở lại ArgoCD UI: https://localhost:8080**

### 4.1 Add Git Repository

1. Click **"Settings"** (menu trái)
2. Click **"Repositories"**
3. Click **"CONNECT REPO"**

**Điền thông tin:**
- **Connection method**: HTTPS
- **Repository URL**: `https://github.com/TamDepTraii/k8s.git`
- **Username**: Your GitHub username
- **Password**: Personal Access Token

Click **"CONNECT"**

### ✅ Repository Connected!

### 4.2 Create Application

1. Click **"Applications"** (menu trái)
2. Click **"NEW APP"**

**Điền thông tin:**

| Trường | Giá Trị |
|--------|--------|
| Application Name | `k8s-app` |
| Project | `default` |
| Repo URL | `https://github.com/TamDepTraii/k8s.git` |
| Path | `k8s/` |
| Destination Server | `https://kubernetes.default.svc` |
| Destination Namespace | `default` |

### 4.3 Enable Auto-Sync

**Kéo xuống "Sync Policy":**
- ✓ Enable **"Automated"**
- ✓ Enable **"Prune Resources"**
- ✓ Enable **"Self Heal"**

### 4.4 Create Application

Click **"CREATE"**

### ✅ Application Created!

Bây giờ ArgoCD sẽ tự động deploy khi bạn push lên Git!

---

## 🎉 Hoàn Thành!

Bạn đã xong tất cả! 

**Tóm tắt:**
- ✅ Đăng nhập ArgoCD
- ✅ Xem Docker Images
- ✅ Push lên GitHub
- ✅ Configure Auto-Deployment

---

## 🔗 Links

| Tài Nguyên | Link |
|-----------|------|
| ArgoCD UI | https://localhost:8080 |
| GitHub Repo | https://github.com/TamDepTraii/k8s |
| Documentation | 00_START_HERE.md |

---

## 📱 Kiểm Tra Kết Quả

### Xem Pods

```powershell
kubectl get pods
```

### Xem Logs

```powershell
kubectl logs -f deployment/k8s-deployment
```

### Xem Services

```powershell
kubectl get svc
```

---

## 🎓 Tiếp Theo Là Gì?

1. **GitHub Actions** - Auto-build Docker image
2. **Webhook** - Tự động sync khi push
3. **Ingress** - External access
4. **SSL/TLS** - HTTPS production
5. **Monitoring** - Prometheus + Grafana

---

## 💾 Important: Credentials

**Lưu thông tin này:**

