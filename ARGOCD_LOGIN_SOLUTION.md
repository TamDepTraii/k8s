
# Port-forward lại
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

---

## 📊 Thông Tin Hữu Ích

### Kiểm Tra Trạng Thái ArgoCD
```powershell
# Xem pods
kubectl -n argocd get pods

# Xem services
kubectl -n argocd get svc

# Xem logs server
kubectl -n argocd logs deployment/argocd-server

# Xem logs repo-server
kubectl -n argocd logs deployment/argocd-repo-server
```

### URLs Quan Trọng
| Dịch Vụ | URL |
|---------|-----|
| ArgoCD UI | `https://localhost:8080` |
| API | `https://localhost:8080/api` |
| Applications | `https://localhost:8080/applications` |

---

## 💾 Lưu Thông Tin Này
**⚠️ Hãy lưu thông tin đăng nhập ở nơi an toàn:**

```
=== ArgoCD Credentials ===
Username: admin
Password: Tmpr4695958
URL: https://localhost:8080
```

---

## 🎓 Tiếp Theo Là Gì?

1. **Setup Application**: Tạo Application trong ArgoCD để deploy ứng dụng
2. **Connect Git Repository**: Kết nối với GitHub repository
3. **Configure Syncing**: Cấu hình tự động sync từ Git
4. **Monitor**: Theo dõi deployment và metrics

---

Liên hệ nếu còn có vấn đề! 🚀
# 🚀 Hướng Dẫn Đăng Nhập ArgoCD - Giải Pháp Lỗi "Invalid"

## ❌ Vấn Đề
Bạn nhận lỗi "Invalid" khi cố gắng đăng nhập vào ArgoCD.

## ✅ Giải Pháp

### 📌 Thông Tin Đăng Nhập ArgoCD

```
Username: admin
Password: Tmpr4695958
```

### 🔧 Các Bước Truy Cập

#### Bước 1: Mở Port-Forward
Chạy lệnh sau trong PowerShell:

```powershell
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

**Kết quả mong muốn:**
```
Forwarding from 127.0.0.1:8080 -> 8443
```

Để bảo tại cửa sổ PowerShell này mở.

#### Bước 2: Truy Cập Web UI
Mở trình duyệt và truy cập:
```
https://localhost:8080
```

**Lưu ý**: Trình duyệt sẽ cảnh báo "Your connection is not private" hoặc tương tự.
- Click "Proceed" hoặc "Advanced" → "Proceed to localhost (unsafe)"

#### Bước 3: Đăng Nhập
- **Username**: `admin`
- **Password**: `Tmpr4695958`
- Click **"SIGN IN"**

---

## 🎯 Xem Docker Images

Sau khi đăng nhập thành công, để xem Docker images đã build:

### Cách 1: Từ Docker CLI
```powershell
# Xem images
docker images

# Tìm image của bạn
docker images | findstr "k8s"
```

### Cách 2: Từ ArgoCD UI
1. Đăng nhập vào ArgoCD
2. Click vào **"Applications"** (menu trái)
3. Chọn ứng dụng của bạn (nếu có)
4. Xem tab "Summary" → "Image"

### Cách 3: Từ Kubernetes
```powershell
# Xem pods
kubectl get pods

# Xem chi tiết pod
kubectl describe pod <pod-name>

# Xem logs
kubectl logs <pod-name>
```

---

## 🐛 Nếu Vẫn Gặp Lỗi

### Lỗi: "Connection refused"
- Kiểm tra port-forward có đang chạy không
- Chạy lại lệnh port-forward

### Lỗi: "SSL/TLS error"
- Đây là bình thường (self-signed certificate)
- Chọn "Advanced" → "Proceed to localhost"

### Lỗi: "Invalid username or password"
- Double-check username và password
- Phân biệt chữ hoa/thường
- Thử xóa cache trình duyệt (Ctrl+Shift+Del)

### Lỗi: Quên mật khẩu
Chạy các lệnh sau để reset:

```powershell
# Xóa secret cũ
kubectl -n argocd delete secret argocd-initial-admin-secret --ignore-not-found=true

# Tạo secret mới
kubectl -n argocd create secret generic argocd-initial-admin-secret --from-literal=password=NewPassword123

# Khởi động lại
kubectl -n argocd rollout restart deployment/argocd-server

# Chờ...
Start-Sleep -Seconds 30

