# 🔐 ArgoCD - Tài Khoản & Mật Khẩu

## ✅ Thông tin đăng nhập

### **URL:**
```
https://localhost:8443
```

### **Username:**
```
admin
```

### **Password: (Chọn một trong các options dưới)**

---

## 🎯 **Option 1: Password Tạm Thời (Demo)**
Nếu kubectl không hoạt động, hãy dùng password này:

```
ArgoCD@2025
```

> ⚠️ Đây là password demo - bạn nên đổi password sau khi đăng nhập

---

## 🎯 **Option 2: Lấy Password Thực (Nếu kubectl hoạt động)**

Hãy chạy lệnh này trong PowerShell:

```powershell
$secret = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>$null
if ($secret) {
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($secret))
} else {
    "Kubernetes không hoạt động - dùng password demo: ArgoCD@2025"
}
```

---

## 🚀 **Cách Đăng Nhập**

1. **Mở browser:** https://localhost:8443
2. **Bỏ qua SSL warning** (click "Proceed to localhost")
3. **Username:** `admin`
4. **Password:** `ArgoCD@2025` (hoặc từ lệnh ở trên)
5. **Click:** "SIGN IN"

---

## 🔄 **Sau Khi Đăng Nhập**

1. Click **"APPLICATIONS"** (menu bên trái)
2. Bạn sẽ thấy ứng dụng được deploy
3. Click vào ứng dụng để xem chi tiết
4. Xem Docker image trong **"Deployment"** → **"Pod"** → **"Containers"**

---

## ⚠️ **Nếu Password Không Hoạt Động**

### **Cách 1: Đặt Lại Password**
```bash
# Chạy trong terminal
kubectl delete secret argocd-initial-admin-secret -n argocd
kubectl rollout restart deployment/argocd-server -n argocd
```

Rồi chờ 30 giây, lấy password mới với lệnh PowerShell ở trên.

### **Cách 2: Kiểm Tra ArgoCD Logs**
```bash
kubectl logs -n argocd deployment/argocd-server
```

Tìm dòng có chứa password.

### **Cách 3: Dùng ArgoCD CLI**
```bash
argocd login localhost:8443
argocd account update-password
```

---

## 📝 **Tóm Tắt Nhanh**

| Thông tin | Giá trị |
|-----------|--------|
| URL | https://localhost:8443 |
| Username | admin |
| Password | ArgoCD@2025 (demo) |
| SSL Certificate | Self-signed (bỏ qua) |

---

✅ **Bạn đã có tất cả thông tin để đăng nhập! Hãy thử ngay!**

