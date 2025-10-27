# 📌 QUICK REFERENCE - Docker Image & ArgoCD

## 🎯 3 Cách Xem Docker Image

### **Cách 1️⃣: Command Line (Nhanh nhất)**
```bash
docker images | grep k8s-demo
```
**Result:**
```
k8s-demo    latest    33f9685a1674    496MB
```

---

### **Cách 2️⃣: Docker Desktop GUI**
1. Mở **Docker Desktop**
2. Chọn tab **Images**
3. Tìm `k8s-demo`
4. Xem chi tiết

---

### **Cách 3️⃣: ArgoCD Dashboard**
1. Truy cập: https://localhost:8443
2. Đăng nhập: `admin` / **[password]**
3. Vào: **Applications** → **k8s-demo-app** → **Application Resources** → **Deployment**
4. Xem container image: `k8s-demo:latest`

---

## 🔐 Lấy Password ArgoCD

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Hoặc PowerShell:
```powershell
$pass = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($pass))
```

---

## 🔗 URLs Quan Trọng

| Dịch vụ | URL | Username | Status |
|---------|-----|----------|--------|
| **Spring Boot** | http://localhost:9090/helloWorld | - | ✅ |
| **ArgoCD** | https://localhost:8443 | admin | ✅ |
| **Health Check** | http://localhost:9090/actuator/health | - | ✅ |
| **Prometheus** | http://localhost:9090/actuator/prometheus | - | ✅ |

---

## 🐳 Docker Image Info

```yaml
Repository: k8s-demo
Tag: latest
Image ID: 33f9685a1674
Size: 496MB
Buildpack: paketobuildpacks/builder:base
Base Image: paketobuildpacks/run:base-cnb
Java: 11
Status: ✅ Ready
```

---

## 📊 Xem Docker Image Layers

```bash
docker history k8s-demo:latest
```

---

## 🚀 Deploy lên Kubernetes ngay

```bash
# 1. Apply Application
kubectl apply -f argocd/application.yaml

# 2. Kiểm tra status
kubectl get applications -n argocd

# 3. Xem logs
kubectl get all -A
```

---

## 💾 Tài Liệu Hữu Ích

- **DASHBOARD.html** - 📊 Visual Dashboard
- **DOCKER_ARGOCD_GUIDE.md** - 📖 Chi tiết hướng dẫn
- **ARGOCD_ACCESS.md** - 🔐 Thông tin truy cập

---

**Bạn đã sẵn sàng! 🎉**

