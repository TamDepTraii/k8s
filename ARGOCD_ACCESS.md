# ArgoCD Access Guide

## 🎯 Thông tin truy cập ArgoCD

### 1. **ArgoCD Web UI URL**
```
https://localhost:8443
```

### 2. **Đăng nhập**
- **Username:** `admin`
- **Password:** Để lấy password, chạy lệnh:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### 3. **Port-Forward Status**
✅ Port-forward đang chạy tại: `8443 -> argocd-server:443`

### 4. **Tính năng chính**
- 📦 Quản lý Applications (ứng dụng Kubernetes)
- 🐳 Xem Docker images
- 📊 Monitoring deployment status
- 🔄 GitOps workflow

### 5. **Để tắt Port-Forward**
```bash
# Ctrl + C trong terminal đang chạy kubectl port-forward
```

---

## 📋 Các bước sử dụng ArgoCD

### Step 1: Mở ArgoCD UI
Truy cập: **https://localhost:8443**

### Step 2: Login
- Username: `admin`
- Password: (Chạy lệnh ở trên để lấy)

### Step 3: Xem Docker Images
1. Click "Applications" menu
2. Chọn ứng dụng
3. Xem Docker image details trong "Application Resources"

---

## 🔗 Related Commands

```bash
# Kiểm tra ArgoCD pods
kubectl get pods -n argocd

# Kiểm tra ArgoCD services
kubectl get svc -n argocd

# Lấy password admin mới
kubectl -n argocd -p /tmp/argocd-pwd.txt get secret argocd-initial-admin-secret

# Scale ArgoCD deployment
kubectl scale deployment argocd-server -n argocd --replicas=2
```

---

✅ **ArgoCD đã được cài đặt và sẵn sàng sử dụng!**

