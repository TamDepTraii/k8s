# 🔐 ArgoCD Login Credentials

## ✅ Thông tin Đăng Nhập

### **URL:** 
```
https://localhost:8443
```

### **Username:**
```
admin
```

### **Password:**
Để lấy password, chạy một trong các lệnh sau:

#### **Option 1: PowerShell**
```powershell
$secret = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($secret))
```

#### **Option 2: Git Bash / WSL**
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

#### **Option 3: Command Prompt**
```cmd
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
```

---

## 📝 **Mật khẩu Mặc Định (Nếu Không Đổi)**

Nếu bạn vừa cài đặt ArgoCD, password mặc định là một chuỗi random được tạo tự động.

### **Cách Tìm:**
1. Mở Terminal / PowerShell
2. Chạy lệnh ở trên
3. Copy password
4. Dán vào ArgoCD login form

---

## 🔄 **Đặt Lại Password** (Nếu Quên)

```bash
# Delete secret cũ
kubectl delete secret argocd-initial-admin-secret -n argocd

# Restart ArgoCD server
kubectl rollout restart deployment/argocd-server -n argocd

# Lấy password mới
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

---

## 🚀 **Cách Đăng Nhập**

1. **Mở browser**: https://localhost:8443
2. **Bỏ qua SSL warning** (nếu có)
3. **Username**: `admin`
4. **Password**: [Paste password từ lệnh trên]
5. **Click**: "Sign In"

---

## ⚠️ **Lưu Ý**

- Password có chứa các ký tự đặc biệt
- Copy chính xác, không bao gồm dòng mới
- Nếu lỗi, thử "Clear Browser Cache"
- SSL certificate là self-signed (có cảnh báo)

---

**✨ Happy Login! 🎉**

