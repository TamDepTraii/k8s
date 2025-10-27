# 🔐 ArgoCD Đăng Nhập - Thông Tin Đầy Đủ

## ✅ Thông Tin Đăng Nhập

### **🌐 URL:**
```
https://localhost:8443
```

### **👤 Username:**
```
admin
```

### **🔑 Password:**

Hãy chạy **một trong các lệnh sau** để lấy password:

---

## 📋 **Cách Lấy Password**

### **Phương pháp 1: PowerShell (Nên Dùng)**
```powershell
# Copy toàn bộ lệnh này vào PowerShell:
$secret = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>$null
if ($secret) {
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($secret))
} else {
    Write-Host "Không thể lấy password - kiểm tra Kubernetes cluster"
}
```

### **Phương pháp 2: Command Prompt**
```cmd
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>nul
```
> ⚠️ Output sẽ là base64 - cần decode

### **Phương pháp 3: Git Bash**
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

---

## 🎯 **Cách Đăng Nhập**

### **Step 1: Mở Browser**
- Truy cập: **https://localhost:8443**
- Bỏ qua SSL warning (click "Advanced" → "Proceed")

### **Step 2: Nhập Thông Tin**
- **Username:** `admin`
- **Password:** [Paste từ lệnh trên]

### **Step 3: Click "Sign In"**

### **Step 4: Xem Docker Image**
- Menu → **Applications**
- Click **k8s-demo-app** (nếu có)
- Chọn **Deployment** → **Pod**
- Xem **Container Image**: `k8s-demo:latest`

---

## ⚠️ **Nếu Password Không Hoạt Động**

### **Tùy chọn 1: Đặt Lại Password**
```bash
# Xóa secret cũ
kubectl delete secret argocd-initial-admin-secret -n argocd

# Khởi động lại ArgoCD server
kubectl rollout restart deployment/argocd-server -n argocd

# Chờ 30 giây, rồi lấy password mới
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### **Tùy chọn 2: Dùng Default Password**
Nếu ArgoCD vừa cài đặt, password mặc định có thể là:
- `admin`
- Được sinh tự động - xem logs:
```bash
kubectl logs -n argocd deployment/argocd-server
```

### **Tùy chọn 3: Dùng ArgoCD CLI**
```bash
# Cài ArgoCD CLI
choco install argocd-cli  # Windows

# Đăng nhập
argocd login localhost:8443

# Đổi password
argocd account update-password --current-password <old> --new-password <new>
```

---

## 🚀 **Troubleshooting**

| Vấn đề | Giải Pháp |
|--------|----------|
| **SSL Error** | Bỏ qua cảnh báo, click "Proceed" |
| **Connection Refused** | Kiểm tra port-forward: `kubectl port-forward svc/argocd-server -n argocd 8443:443` |
| **Invalid Credentials** | Thử đặt lại password (xem tùy chọn 1) |
| **Pod không chạy** | `kubectl get pods -n argocd` - kiểm tra pods |

---

## 📝 **Ghi Chú**

- Password có thể chứa ký tự đặc biệt (!, @, #, etc.)
- Copy chính xác, không bao gồm dấu cách hoặc dòng mới
- Mỗi lần cài ArgoCD mới có password khác
- Password lưu trong Kubernetes secret: `argocd-initial-admin-secret`

---

## 📞 **Hỗ Trợ Nhanh**

```bash
# Kiểm tra ArgoCD namespace
kubectl get namespace argocd

# Kiểm tra pods
kubectl get pods -n argocd

# Kiểm tra services
kubectl get svc -n argocd

# Xem logs
kubectl logs -n argocd deployment/argocd-server -f
```

---

**✅ Bạn đã có tất cả thông tin cần thiết! 🎉**

**Hãy chạy lệnh password và đăng nhập vào ArgoCD ngay!**

