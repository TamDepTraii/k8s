# Hướng Dẫn Đăng Nhập ArgoCD

## Vấn Đề Gặp Phải
Bạn gặp lỗi "invalid" khi cố gắng đăng nhập vào ArgoCD.

## Giải Pháp

### Bước 1: Lấy Mật Khẩu Admin Ban Đầu

Mở PowerShell và chạy lệnh sau để lấy mật khẩu:

```powershell
$password = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($password))
```

**Thông Tin Đăng Nhập:**
- **Username**: `admin`
- **Password**: (Kết quả từ lệnh trên)

### Bước 2: Port-Forward Để Truy Cập ArgoCD

Chạy lệnh sau để mở tunnel:

```powershell
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

### Bước 3: Truy Cập UI

Mở trình duyệt và truy cập:
```
https://localhost:8080
```

**Lưu Ý**: Trình duyệt sẽ cảnh báo về SSL/TLS. Chọn "Tiếp tục" hoặc "Accept Risk".

### Bước 4: Đăng Nhập

- Nhập username: `admin`
- Nhập password: (mật khẩu từ Bước 1)
- Click "SIGN IN"

### Bước 5: Thay Đổi Mật Khẩu (Tùy Chọn)

Sau khi đăng nhập thành công:
1. Click vào biểu tượng người dùng (góc trên phải)
2. Chọn "User Info"
3. Click "Change Password"
4. Nhập mật khẩu mới

## Nếu Vẫn Không Hoạt Động

### Cách 1: Reset Password Bằng Patch

```powershell
# Base64 encode mật khẩu mới (ví dụ: "newpassword123")
$password = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("newpassword123"))

# Patch secret
kubectl -n argocd patch secret argocd-secret -p "{`"data`":{`"admin.password.bcrypt`":`"$password`"}}"
```

### Cách 2: Xóa và Tạo Lại Secret

```powershell
# Xóa secret cũ
kubectl -n argocd delete secret argocd-initial-admin-secret

# Khởi động lại server
kubectl -n argocd rollout restart deployment/argocd-server

# Đợi pod sẵn sàng
kubectl -n argocd wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --timeout=60s

# Lấy mật khẩu mới
$password = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($password))
```

## Xem Container Images

Để xem Docker images đã build:

```powershell
# Xem images cục bộ
docker images | Select-String "k8s"

# Hoặc trong ArgoCD UI:
# 1. Đi tới Applications
# 2. Chọn application của bạn
# 3. Xem chi tiết pod và image được sử dụng
```

## Kiểm Tra ArgoCD Status

```powershell
# Xem pods
kubectl -n argocd get pods

# Xem services
kubectl -n argocd get svc

# Xem logs
kubectl -n argocd logs deployment/argocd-server
```

## URL Truy Cập

- **ArgoCD UI**: `https://localhost:8080` (sau khi chạy port-forward)
- **ArgoCD API**: `https://localhost:8080/api`

---

**Ghi Chú**: Lần đầu tiên truy cập, mật khẩu sẽ được tạo ngẫu nhiên. Bạn PHẢI đăng nhập để có thể sử dụng ArgoCD.

